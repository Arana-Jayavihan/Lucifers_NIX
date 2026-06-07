{
  description = "Lucifer's NIX";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-colors.url = "github:misterio77/nix-colors";
    ags.url = "github:/Aylur/ags/v1";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      rev = "39d7e209c79d451efab1b21151d5938289da838d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      type = "git";
      url = "https://github.com/nix-community/nixvim";
      #rev = "0e8b4ccf0a4e4e90f9ca39295e807628a6e575e6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      type = "git";
      url = "https://github.com/nix-community/flake-firefox-nightly.git";
      #rev = "d20be2e9c1b201e4253e79a200f0a2ed7fc27441";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-claude-code.url = "github:ryoppippi/nix-claude-code";
    androcontrol = {
      url = "github:Arana-Jayavihan/AndroControl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs-unstable, nixpkgs, home-manager, nix-colors, firefox, nix-claude-code, ... }:
    let

      system = "x86_64-linux";

      inherit (import ./options.nix) username;

      # Separate (intentional) nixpkgs evaluation for packages we want from unstable.
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Overlays applied to the system nixpkgs (single evaluation, shared by both hosts).
      overlays = [
        # nix-colors' gtk-theme contrib still references the removed
        # `nodePackages.sass`; alias it to the modern dart-sass.
        (final: _prev: { nodePackages = { sass = final.dart-sass; }; })
        nix-claude-code.overlays.default
      ];

      # Build a host configuration by name. Shared options come from ./options.nix;
      # per-host overrides come from ./hosts/<host>/options.nix. The merged set is
      # passed to all modules as `opt` (and the hardware module is injected here).
      mkHost = host:
        let
          opt = (import ./options.nix) // (import ./hosts/${host}/options.nix);
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs username opt pkgs-unstable firefox;
            hostname = opt.hostname;
          };
          modules = [
            ./hosts/${host}/hardware.nix
            ./system.nix
            inputs.sops-nix.nixosModules.sops
            ({ pkgs, ... }: {
              nixpkgs.overlays = overlays;
              environment.systemPackages = [
                pkgs.claude-code
              ];
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username inputs opt pkgs-unstable firefox;
                hostname = opt.hostname;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };

      # Build a headless server host. Deliberately minimal: no ./system.nix,
      # no home-manager, no overlays — nothing shared with the desktop hosts.
      # morph-only options (deployment.*) are added by ./morph/network.nix, not
      # here, so this stays a valid plain nixosConfiguration.
      mkServer = host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            ./hosts/${host}/hardware.nix
            ./hosts/${host}/default.nix
            inputs.sops-nix.nixosModules.sops
            ./hosts/${host}/sops.nix
          ];
        };

    in
    {
      nixosConfigurations = {
        shire = mkHost "shire";
        gondor = mkHost "gondor";
        mordor = mkServer "mordor";
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        packages = with nixpkgs.legacyPackages.${system}; [
          nixpkgs-fmt
          deadnix
          statix
          nil
        ];
      };
    };
}
