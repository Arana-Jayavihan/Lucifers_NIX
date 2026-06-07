{ pkgs, flakeDir, ... }:

# Wrapper around morph for the `mordor` (H3LL) DigitalOcean droplet. Lives on
# the desktop hosts (shire/gondor) where deploys are run from. The droplet's
# config is hosts/mordor/, deployed via morph/network.nix.
pkgs.writeShellScriptBin "mordor" ''
  set -euo pipefail

  NET="${flakeDir}/morph/network.nix"
  morph="${pkgs.morph}/bin/morph"

  usage() {
    cat <<'EOF'
  Usage: mordor [command] [extra morph args]

  Build / deploy the `mordor` (H3LL) DigitalOcean droplet via morph.

  Commands:
    build         Build the configuration locally            (default)
    deploy        Build, push and `switch` on the droplet
    dry           Show what a deploy would change (--dry-run)
    push          Build + copy closure to the droplet (no activate)
    health        Run morph health checks
    <other>       Passed straight through: morph <other> <network.nix>

  Examples:
    mordor                # build
    mordor deploy         # build + push + switch
    mordor dry            # preview changes
EOF
  }

  cmd="''${1:-build}"
  shift || true

  case "$cmd" in
    -h|--help|help) usage ;;
    build)          exec "$morph" build "$NET" "$@" ;;
    deploy)         exec "$morph" deploy "$NET" switch "$@" ;;
    dry)            exec "$morph" --dry-run deploy "$NET" switch "$@" ;;
    push)           exec "$morph" push "$NET" "$@" ;;
    health)         exec "$morph" check-health "$NET" "$@" ;;
    *)              exec "$morph" "$cmd" "$NET" "$@" ;;
  esac
''
