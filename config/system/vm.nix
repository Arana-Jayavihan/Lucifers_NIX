{ pkgs, config, lib, opt, ... }:

lib.mkIf (opt.cpuType == "vm") {
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}
