{ pkgs }:

pkgs.writeShellScriptBin "screenshootin" ''
  set -euo pipefail

  # Select a region (exit quietly if the selection is cancelled), then edit it.
  geometry=$(${pkgs.slurp}/bin/slurp) || exit 0
  [ -n "$geometry" ] || exit 0

  ${pkgs.grim}/bin/grim -g "$geometry" - | ${pkgs.swappy}/bin/swappy -f -
''
