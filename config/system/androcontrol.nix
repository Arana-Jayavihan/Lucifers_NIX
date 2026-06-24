{ inputs, ... }:
{
  imports = [ inputs.androcontrol.nixosModules.default ];

  services.androcontrol = {
    enable = true;
    port = 5050;
    openFirewall = false;
    dataDir = "/var/lib/androcontrol";
    desktopNotifications = true;
    clipboardSync = true;
    fileTransfer = true;
  };
}
