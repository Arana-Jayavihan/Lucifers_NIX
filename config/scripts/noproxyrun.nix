{ pkgs }:

pkgs.writeShellScriptBin "noproxyrun" ''
  set -euo pipefail

  usage() {
    cat <<'EOF'
Usage: noproxyrun <command> [args...]

Run a command with all proxy environment variables disabled.

Examples:
  noproxyrun curl https://example.com
  noproxyrun git pull
EOF
  }

  if [ "$#" -eq 0 ]; then
    usage >&2
    exit 1
  fi
  case "$1" in
    -h|--help) usage; exit 0 ;;
  esac

  unset all_proxy http_proxy https_proxy rsync_proxy ftp_proxy \
        ALL_PROXY HTTP_PROXY HTTPS_PROXY RSYNC_PROXY FTP_PROXY

  exec "$@"
''
