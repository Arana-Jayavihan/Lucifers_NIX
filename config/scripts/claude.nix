{ pkgs, ... }:

pkgs.writeShellScriptBin "np-claude" ''
  set -euo pipefail

  # Run Claude Code with proxies disabled (forwards all arguments).
  unset all_proxy http_proxy https_proxy rsync_proxy ftp_proxy \
        ALL_PROXY HTTP_PROXY HTTPS_PROXY RSYNC_PROXY FTP_PROXY

  # Use the same claude-code the `claude` command uses: the nix-claude-code
  # flake package (applied via overlay), so `nix flake update nix-claude-code`
  # updates this script too.
  exec ${pkgs.claude-code}/bin/claude "$@"
''
