{ config, lib, opt, ... }:

lib.mkIf (opt.localHWClock == true) {
  time.hardwareClockInLocalTime = true;
}
