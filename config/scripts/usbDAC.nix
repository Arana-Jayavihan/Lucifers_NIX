{ pkgs, ... }:

pkgs.writeShellScriptBin "usbDAC" ''
  # Unmute and max the PCM volume on USB DAC cards once they settle.
  # Tolerant of missing cards (set -e intentionally omitted).
  set -uo pipefail

  sleep 1
  for card in 0 1; do
    ${pkgs.alsa-utils}/bin/amixer -c "$card" set PCM 100% unmute -q 2>/dev/null || true
  done
''
