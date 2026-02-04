{ pkgs, pkgs-unstable, ... }:

pkgs.writeShellScriptBin "np-claude" ''
export all_proxy= &&
export http_proxy= &&
export https_proxy= &&
export rsync_proxy= &&
export ftp_proxy= &&
${pkgs-unstable.claude-code}/bin/claude
''
