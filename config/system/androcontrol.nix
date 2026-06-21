{ inputs, ... }:
{
  # AndroControl — secure remote mouse/keyboard control for this machine from an
  # Android phone (TLS + per-device pairing tokens, input injected via uinput).
  #
  # The package and a NixOS module come from its own flake (inputs.androcontrol).
  # The module creates a dedicated system user, loads the `uinput` kernel module,
  # installs the udev rule that grants the `input` group access to /dev/uinput,
  # and defines the hardened systemd unit.
  imports = [ inputs.androcontrol.nixosModules.default ];

  services.androcontrol = {
    enable = true;

    # Listen port. 5050 is the default and is already opened by the global
    # `firewallPorts` list in options.nix, so we keep openFirewall = false here
    # to avoid declaring the same port twice.
    port = 5050;
    openFirewall = false;

    # Where TLS certs, the enrollment token, and the paired-device registry
    # (devices.json) are stored. Persisted across reboots/rebuilds.
    dataDir = "/var/lib/androcontrol";

    # The service binds 0.0.0.0 by default so the phone can reach it over the LAN.
    # To restrict to loopback only (e.g. reach it via a VPN / SSH tunnel), set:
    #   bindAddress = "127.0.0.1";
    # NOTE: `bindAddress` requires updating the androcontrol flake input to a
    # revision that includes it (`nix flake update androcontrol`).
  };

  # ── Operating notes ──────────────────────────────────────────────────────────
  # First-run setup / pairing:
  #   journalctl -u androcontrol -f      # shows the QR code, enrollment token,
  #                                      # and the TLS certificate fingerprint
  # Scan the QR (or enter the token) in the app; the phone then receives its own
  # per-device token and the enrollment token is discarded on the device.
  #
  # Manage paired devices (data lives in dataDir above):
  #   cd /var/lib/androcontrol && AndroControl -list-devices
  #   cd /var/lib/androcontrol && AndroControl -revoke <device-id>
  #
  # Rotate the enrollment token (forces re-pairing of new devices):
  #   rm /var/lib/androcontrol/auth_token && systemctl restart androcontrol
}
