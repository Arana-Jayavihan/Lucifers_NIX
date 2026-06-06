{ pkgs }:

# Regenerates the AndroControl pairing QR code from the *running service's*
# persisted auth token, independent of the service's stdout. Because the token
# lives in the service's data dir (root/androcontrol-owned, mode 0600), reading
# it needs sudo. The QR payload is the same JSON the server itself encodes:
#   {"name","ip","port","token"}
pkgs.writeShellScriptBin "androcontrol-qr" ''
  set -euo pipefail

  DATADIR="''${ANDROCONTROL_DATADIR:-/var/lib/androcontrol}"
  PORT="''${ANDROCONTROL_PORT:-5050}"
  TOKEN_FILE="$DATADIR/auth_token"

  case "''${1:-}" in
    -h|--help)
      echo "Usage: androcontrol-qr"
      echo
      echo "Render the AndroControl pairing QR code from the service's stored token."
      echo "  (default)   print a scannable QR in the terminal"
      echo
      echo "Env: ANDROCONTROL_DATADIR (default /var/lib/androcontrol)"
      echo "     ANDROCONTROL_PORT    (default 5050)"
      exit 0 ;;
    "") ;;
    *) echo "Unknown argument: $1 (try --help)" >&2; exit 1 ;;
  esac

  # The token file is mode 0600 and owned by the service user, so read via sudo
  # (use the PATH sudo so the setuid wrapper is picked up, not a store path).
  if ! TOKEN=$(sudo cat "$TOKEN_FILE" 2>/dev/null); then
    echo "Could not read $TOKEN_FILE." >&2
    echo "Is the androcontrol service enabled and has it started at least once?" >&2
    exit 1
  fi
  TOKEN=$(printf '%s' "$TOKEN" | tr -d '[:space:]')
  if [ -z "$TOKEN" ]; then
    echo "Token file $TOKEN_FILE is empty." >&2
    exit 1
  fi

  # First global-scope IPv4 address — matches the server's GetLocalIP() choice.
  IP=$(${pkgs.iproute2}/bin/ip -4 -o addr show scope global \
        | ${pkgs.gawk}/bin/awk '{print $4}' | ${pkgs.coreutils}/bin/cut -d/ -f1 \
        | ${pkgs.coreutils}/bin/head -n1)
  if [ -z "$IP" ]; then
    echo "Could not determine a global IPv4 address." >&2
    exit 1
  fi

  HOST=$(${pkgs.coreutils}/bin/cat /proc/sys/kernel/hostname)
  [ -n "$HOST" ] || HOST="AndroControl"

  JSON=$(${pkgs.coreutils}/bin/printf '{"name":"%s","ip":"%s","port":%s,"token":"%s"}' \
          "$HOST" "$IP" "$PORT" "$TOKEN")

  echo "Server: $HOST   IP: $IP   Port: $PORT"

  printf '%s' "$JSON" | ${pkgs.qrencode}/bin/qrencode -t ANSIUTF8
''
