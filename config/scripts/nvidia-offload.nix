{ pkgs }:

pkgs.writeShellScriptBin "nvidia-offload" ''
  set -euo pipefail

  if [ "$#" -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: nvidia-offload <command> [args...]" >&2
    echo "Run a command on the NVIDIA GPU via PRIME render offload." >&2
    [ "$#" -eq 0 ] && exit 1 || exit 0
  fi

  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export __VK_LAYER_NV_optimus=NVIDIA_only

  exec "$@"
''
