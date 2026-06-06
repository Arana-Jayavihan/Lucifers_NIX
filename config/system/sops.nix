{ lib, hostname, ... }:

{
  # sops-nix: secrets are decrypted at activation using this host's SSH host key
  # as the age identity. The matching age *recipients* live in ../../.sops.yaml.
  #
  # Workflow:
  #   - Edit secrets:  sudo sops secrets/secrets.yaml   (uses the host key identity)
  #   - Add gondor:    cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age   -> add to .sops.yaml
  #                    then: sops updatekeys secrets/secrets.yaml
  #   - First real use: put e.g. the openfortivpn config in the secret and point the
  #     consumer at config.sops.secrets."<name>".path (decrypts under /run/secrets).
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Example secret, scoped to hosts that are recipients in .sops.yaml. gondor is
    # not a recipient yet, so guard on hostname to keep it building. Decrypts to
    # /run/secrets/example_key and is not consumed by anything — safe placeholder.
    secrets = lib.mkIf (hostname == "shire") {
      example_key = { };
    };
  };
}
