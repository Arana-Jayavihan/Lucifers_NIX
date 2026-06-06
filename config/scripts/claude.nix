{ pkgs, pkgs-unstable, ... }:

pkgs.writeShellScriptBin "np-claude" ''
  set -euo pipefail

  # Run Claude Code with proxies disabled (forwards all arguments).
  unset all_proxy http_proxy https_proxy rsync_proxy ftp_proxy \
        ALL_PROXY HTTP_PROXY HTTPS_PROXY RSYNC_PROXY FTP_PROXY

  exec ${pkgs-unstable.claude-code}/bin/claude "$@"
''
