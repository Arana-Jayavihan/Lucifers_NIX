{ pkgs, ... }:

pkgs.writeShellScriptBin "webshare" ''
  set -euo pipefail

  export PATH="${pkgs.lib.makeBinPath [ pkgs.python3 pkgs.iproute2 pkgs.gawk pkgs.coreutils ]}:$PATH"

  PORT=5000
  TARGET=""

  usage() {
    cat <<'EOF'
  Usage: webshare [-p PORT] <file|folder>

  Serve a file or a folder over HTTP on the local network (binds 0.0.0.0).

    -p, --port PORT   Port to listen on (default: 5000)
    -h, --help        Show this help

  Examples:
    webshare .                    # share the current folder on :5000
    webshare -p 8080 ~/Downloads  # share a folder on :8080
    webshare ./report.pdf         # share a single file only
  EOF
  }

  # ---- parse args ----
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      -p|--port) PORT="''${2:-}"; shift 2 ;;
      -*) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
      *)
        if [ -n "$TARGET" ]; then
          echo "Error: only one file/folder can be shared at a time" >&2
          exit 1
        fi
        TARGET="$1"; shift ;;
    esac
  done

  # ---- validate ----
  if [ -z "$TARGET" ]; then
    echo "Error: no file or folder specified" >&2
    usage >&2
    exit 1
  fi
  if [ ! -e "$TARGET" ]; then
    echo "Error: '$TARGET' does not exist" >&2
    exit 1
  fi
  case "$PORT" in *[!0-9]*) echo "Error: invalid port '$PORT'" >&2; exit 1 ;; esac
  [ -n "$PORT" ] || { echo "Error: invalid port" >&2; exit 1; }

  # ---- work out the LAN address to advertise ----
  LAN_IP="$(ip route get 1.1.1.1 2>/dev/null \
    | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')"
  LAN_IP="''${LAN_IP:-0.0.0.0}"

  CLEANUP=""
  cleanup() { [ -n "$CLEANUP" ] && rm -rf "$CLEANUP" || true; }
  trap cleanup EXIT INT TERM

  if [ -d "$TARGET" ]; then
    SERVE_DIR="$(realpath "$TARGET")"
    echo "Sharing folder: $SERVE_DIR"
    echo "  -> http://$LAN_IP:$PORT/"
  else
    # Single file: serve a throwaway dir holding just a symlink to it, so the
    # rest of the file's real directory stays private.
    FILE_REAL="$(realpath "$TARGET")"
    FILE_NAME="$(basename "$FILE_REAL")"
    SERVE_DIR="$(mktemp -d)"
    CLEANUP="$SERVE_DIR"
    ln -s "$FILE_REAL" "$SERVE_DIR/$FILE_NAME"
    echo "Sharing file: $FILE_REAL"
    echo "  -> http://$LAN_IP:$PORT/$FILE_NAME"
  fi

  echo "Press Ctrl-C to stop."

  # Serve with a small handler that (a) supports HTTP Range requests so media
  # players can stream/seek, and (b) ignores client disconnects instead of
  # dumping a BrokenPipeError traceback. Not exec'd, so the cleanup trap runs.
  python3 - "$SERVE_DIR" 0.0.0.0 "$PORT" <<'PYEOF'
  import http.server, os, sys

  DIRECTORY, BIND, PORT = sys.argv[1], sys.argv[2], int(sys.argv[3])

  class Handler(http.server.SimpleHTTPRequestHandler):
      def __init__(self, *a, **k):
          super().__init__(*a, directory=DIRECTORY, **k)

      def copyfile(self, source, outputfile):
          remaining = getattr(self, "_range_len", None)
          try:
              if remaining is None:
                  super().copyfile(source, outputfile)
              else:
                  while remaining > 0:
                      chunk = source.read(min(65536, remaining))
                      if not chunk:
                          break
                      outputfile.write(chunk)
                      remaining -= len(chunk)
          except (BrokenPipeError, ConnectionResetError):
              pass

      def send_head(self):
          rng = self.headers.get("Range")
          path = self.translate_path(self.path)
          if rng is None or os.path.isdir(path):
              self._range_len = None
              return super().send_head()
          try:
              f = open(path, "rb")
          except OSError:
              self.send_error(404, "File not found")
              return None
          size = os.fstat(f.fileno()).st_size
          try:
              unit, _, spec = rng.partition("=")
              if unit.strip().lower() != "bytes":
                  raise ValueError
              s, _, e = spec.strip().partition("-")
              if s == "":
                  start, end = max(0, size - int(e)), size - 1
              else:
                  start, end = int(s), (int(e) if e else size - 1)
              end = min(end, size - 1)
              if start > end or start >= size:
                  raise ValueError
          except ValueError:
              f.close()
              self.send_response(416)
              self.send_header("Content-Range", "bytes */%d" % size)
              self.end_headers()
              return None
          self._range_len = end - start + 1
          self.send_response(206)
          self.send_header("Content-Type", self.guess_type(path))
          self.send_header("Accept-Ranges", "bytes")
          self.send_header("Content-Range", "bytes %d-%d/%d" % (start, end, size))
          self.send_header("Content-Length", str(self._range_len))
          self.send_header("Last-Modified", self.date_time_string(os.fstat(f.fileno()).st_mtime))
          self.end_headers()
          f.seek(start)
          return f

  try:
      http.server.ThreadingHTTPServer((BIND, PORT), Handler).serve_forever()
  except KeyboardInterrupt:
      pass
  PYEOF
''
