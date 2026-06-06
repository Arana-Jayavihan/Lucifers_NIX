{ pkgs, ... }:

pkgs.writeShellScriptBin "pyvenv" ''
  set -euo pipefail

  case "''${1:-}" in
    -h|--help)
      echo "Usage: pyvenv"
      echo "Create a .venv in the current directory (with proxies disabled for pip)"
      echo "and install pip + pysocks. Activate afterwards with:"
      echo "  source .venv/bin/activate"
      exit 0 ;;
  esac

  if [ -e .venv ]; then
    echo "Error: a .venv already exists in $(pwd)" >&2
    exit 1
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 not found on PATH" >&2
    exit 1
  fi

  # Build the venv with proxies disabled so pip can reach PyPI directly.
  unset all_proxy http_proxy https_proxy rsync_proxy ftp_proxy \
        ALL_PROXY HTTP_PROXY HTTPS_PROXY RSYNC_PROXY FTP_PROXY

  python3 -m venv .venv
  .venv/bin/pip install --upgrade pip
  .venv/bin/pip install pysocks

  echo "Created .venv — activate it with: source .venv/bin/activate"
''
