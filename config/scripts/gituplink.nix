{ pkgs, flakeDir }:

pkgs.writeShellScriptBin "gitUplink" ''
if [ "$1" == 0 ];
then
  printf "Enter Commit Message"
else
  cd ${flakeDir}
  git add .
  git commit -m "$1"
  git push
fi
''
