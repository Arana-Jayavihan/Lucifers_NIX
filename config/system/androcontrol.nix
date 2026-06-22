{ inputs, ... }:
{
  # Secure remote mouse/keyboard control from an Android phone over mutual TLS.
  imports = [ inputs.androcontrol.nixosModules.default ];

  services.androcontrol = {
    enable = true;

    # 5050 is already opened by the global firewallPorts list, so don't reopen it.
    port = 5050;
    openFirewall = false;

    dataDir = "/var/lib/androcontrol";

    # bindAddress = "127.0.0.1";  # loopback only (reach via VPN/SSH tunnel)

    # Desktop popups on device connect/disconnect (per-user journal watcher + notify-send).
    desktopNotifications = true;
  };

  # Pairing / management: `sudo androcontrol-ctl qr | regen-token | list | revoke <id|name>`.
}
