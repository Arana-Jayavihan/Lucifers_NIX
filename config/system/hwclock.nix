{ config, lib, ... }:

let inherit (import ../../options.nix) localHWClock; in
lib.mkIf (localHWClock == true) {
  time.hardwareClockInLocalTime = true;
}
