{ pkgs }:

pkgs.writeShellScriptBin "noproxyrun" ''
  export all_proxy= &&
  export http_proxy= &&
  export https_proxy= &&
  export rsync_proxy= &&
  export ftp_proxy= &&
  "$1"
''
