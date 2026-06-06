{ pkgs, flakeDir }:

pkgs.writeShellScriptBin "gitUplink" ''
  set -euo pipefail

  case "''${1:-}" in
    -h|--help|"")
      echo "Usage: gitUplink <commit message>"
      echo "Stage, commit, and push the flake repository."
      [ "''${1:-}" = "" ] && exit 1 || exit 0 ;;
  esac

  cd "${flakeDir}"

  ${pkgs.git}/bin/git add -A

  # Nothing staged means nothing to do.
  if ${pkgs.git}/bin/git diff --cached --quiet; then
    echo "Nothing to commit."
    exit 0
  fi

  ${pkgs.git}/bin/git commit -m "$*"
  ${pkgs.git}/bin/git push
''
