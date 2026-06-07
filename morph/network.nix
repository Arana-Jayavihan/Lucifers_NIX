# morph network expression for the `mordor` (a.k.a. `hell`) droplet.
#
# morph 1.8 is NOT flake-native: it does `import <this file>` and reads each
# top-level attribute as a machine module, injecting its own deployment.*
# options. So this thin bridge imports the exact same host modules that
# flake.nix's `nixosConfigurations.mordor` uses (single source of truth) and
# adds only the morph-specific deployment metadata.
#
# Deploy:   morph deploy ./morph/network.nix switch
# Build:    morph build  ./morph/network.nix
#
# `network.pkgs` is pinned to the same nixpkgs revision as ../flake.lock so
# morph builds reproducibly match the flake instead of floating on whatever
# <nixpkgs> channel happens to be set.
let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b51242d7d43689db2f3be91bd05d5b24fbb469c4.tar.gz";
    sha256 = "sha256-K5sT4jTpGs15ADhviMKNBH38REpPf5Q6mM1+N6cArVE=";
  };

  # sops-nix, pinned to the same rev as ../flake.lock. morph isn't flake-aware,
  # so the module is imported by store path instead of inputs.sops-nix.
  sops-nix = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/9ed65852b6257fbeae4355bc24ecfea307ca759a.tar.gz";
    sha256 = "sha256-Gq8KNx5A7hBB3uGJaj6eQfLDIz5YdLu92gqBcvHvoUo=";
  };
in
{
  network.pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  mordor = { ... }: {
    imports = [
      "${sops-nix}/modules/sops"
      ../hosts/mordor/hardware.nix
      ../hosts/mordor/default.nix
      ../hosts/mordor/sops.nix
    ];

    deployment.targetHost = "hell";
    deployment.targetUser = "root";
  };
}
