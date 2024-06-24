{ pkgs, ... }:

pkgs.writeShellScriptBin "pyvenv" ''
export all_proxy= &&
export http_proxy= &&
export https_proxy= &&
export rsync_proxy= &&
export ftp_proxy= &&
python3 -m venv .venv && 
source .venv/bin/activate && 
pip install --upgrade pip &&
pip install pysocks
export all_proxy=socks5://127.0.0.1:1080 &&
export rsync_proxy=socks5://127.0.0.1:1080 &&
export http_proxy=http://127.0.0.1:1090 &&
export https_proxy=http://127.0.0.1:1090 &&
export ftp_proxy=http://127.0.0.1:1090
''
