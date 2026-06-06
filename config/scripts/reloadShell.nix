{ pkgs, ... }:

pkgs.writeShellScriptBin "reloadShell" ''
  # Restart the AGS shell and reload notifications. Tolerant of nothing running.
  set -uo pipefail

  # Use the AGS v1 binary from PATH (provided by programs.ags via the ags/v1
  # flake input) — `pkgs.ags` is now AGS v2 (Astal) and ignores this v1 config.
  ${pkgs.procps}/bin/pkill -9 -f ags-wrapped 2>/dev/null || true
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs 2>/dev/null || true
  ags -q 2>/dev/null || true

  exec ags
''
