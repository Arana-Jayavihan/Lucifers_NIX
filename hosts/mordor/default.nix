# Host `mordor` — headless DigitalOcean SSL-VPN / services droplet.
#
# Ported from the standalone cloudNix repo (cloudNix/system.nix). This is a
# plain, self-contained NixOS module: it deliberately does NOT import the
# desktop ../../system.nix, ../../home.nix, home-manager or any overlays, so
# it shares nothing with the shire/gondor desktop hosts.
#
# morph-specific options (deployment.targetHost/targetUser) live in
# ../../morph/network.nix, not here, so this module stays a valid plain
# nixosConfiguration for `nix flake check`.
{ config, pkgs, ... }:

{
  system.stateVersion = "23.11";

  # Headless droplet: don't install per-package HTML "doc" outputs. Besides
  # being useless on a server, the python 3.11 doc build is broken in this
  # nixpkgs (upstream sphinx/docutils bug), and pulling it into the system
  # path would break every rebuild. man/info pages are still installed.
  documentation.doc.enable = false;

  environment.variables = {
    TERM = "linux";
  };

  environment.systemPackages = with pkgs; [
    tshark
    wireshark
    python311
    unzip
    inetutils
    file
    screen
    git
  ];

  networking = {
    hostName = "H3LL";
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 5446 5000 443 5050 9000 80 ];
    firewall.allowedUDPPorts = [ 53 ];
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  services.openssh = {
    enable = true;
    ports = [ 5322 ];
    openFirewall = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
    settings.GatewayPorts = "yes";
    #    settings.AllowGroups = [ "SSHUsers" "users" ];
    extraConfig = ''
      LoginGraceTime 20
    '';
  };

  services.rsyslogd = {
    enable = false;
    defaultConfig = "";
    extraConfig = ''
      module(
        load="imptcp"
        Threads="2"
      )

      input(
        type="imptcp"
        port="9000"
      )

      if $syslogtag == 'local7' then {
        action(type="omfile" file="/tmp/test.log")
      stop
      }

      if $syslogfacility-text == 'local7' then {
        action(type="omfile" file="/tmp/test.log")
      stop
      }

      action(type="omfile" dirCreateMode="0700" FileCreateMode="0644" File="/tmp/all.log")'';
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."165.22.52.204" = {
    onlySSL = true;
    sslCertificate = "/nginx/sites/simpleWeb/cert.pem";
    sslCertificateKey = "/nginx/sites/simpleWeb/key.pem";
    extraConfig = ''
      add_header 'X-Frame-Options' 'SAMEORIGIN';
      add_header 'X-Content-Type-Options'  'nosniff';
      add_header 'X-XSS-Protection' '1; mode=block';
      add_header 'Strict-Transport-Security' 'max-age=31536000; includeSubDomains; preload';
      add_header 'Content-Security-Policy' "default-src 'self'; font-src 'self'; img-src 'self'; script-src 'self'; style-src 'self'; frame-src 'self'";
      add_header 'Permissions-Policy' 'camera=(), geolocation=(), microphone=()';
      add_header 'Referrer-Policy' 'same-origin';
    '';
    locations = {
      "/" = {
        # Credentials are not committed in cleartext; the htpasswd file is a
        # sops secret (secrets/mordor.yaml), decrypted to /run/secrets at
        # activation. Edit with: sudo sops secrets/mordor.yaml
        basicAuthFile = config.sops.secrets.nginx_basic_auth.path;
        root = "/nginx/sites/simpleWeb/src";
        extraConfig = ''
          location /content/ {
            autoindex on;
          }
        '';
      };
    };
  };

  services.cockpit = {
    enable = true;
    openFirewall = true;
  };

  # SSL VPN: stunnel wraps the SSH service (port 5322) in TLS.
  services.stunnel = {
    enable = true;
    user = "lucifer";
    group = "users";
    servers = {
      sshd = {
        accept = 5446;
        connect = 5322;
        cert = "/services/stunnel/cert.pem";
        key = "/services/stunnel/key.pem";
        TIMEOUTbusy = 30;
        TIMEOUTclose = 10;
        TIMEOUTconnect = 30;
        TIMEOUTidle = 600;
      };
      secureTunnel = {
        accept = 80;
        connect = 5322;
        cert = "/services/stunnel/cert.pem";
        key = "/services/stunnel/key.pem";
      };
    };
  };

  services.dnscrypt-proxy2 = {
    enable = false;
    configFile = "/services/dnscrypt/dnscrypt.toml";
  };

  services.cron.enable = true;
}
