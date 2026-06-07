# sops-nix configuration for `mordor`.
#
# Secrets are decrypted at activation using this host's SSH host key as the
# age identity. mordor's age *recipient* lives in ../../.sops.yaml and the
# encrypted values in ../../secrets/mordor.yaml.
#
# Workflow:
#   - Edit secrets:  sudo sops secrets/mordor.yaml   (works from shire too)
#   - Rotate host key recipient: ssh-keyscan -p 5322 -t ed25519 165.22.52.204 \
#       | ssh-to-age   -> update &mordor in .sops.yaml, then
#       sops updatekeys secrets/mordor.yaml
{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/mordor.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # htpasswd file for the nginx virtualhost basic-auth. Owned by the nginx
    # user so the worker process can read it on each request.
    secrets.nginx_basic_auth = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
    };
  };
}
