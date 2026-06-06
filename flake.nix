{
  description = "Lucifer's NIX";

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
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    burpsuitepro = {
      type = "github";
      owner = "xiv3r";
      repo = "Burpsuite-Professional";
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
  };

  outputs = inputs@{ nixpkgs-unstable, nixpkgs, home-manager, nix-colors, firefox, nix-claude-code, burpsuitepro, ... }:
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
      (final: prev: { nodePackages = { sass = final.dart-sass; }; })
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
          ({ pkgs, ... }: {
            nixpkgs.overlays = overlays;
            environment.systemPackages = [
              pkgs.claude-code
              #burpsuitepro.packages.${system}.default
            ];
          })
          home-manager.nixosModules.home-manager {
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

  in {
    nixosConfigurations = {
      shire = mkHost "shire";
      gondor = mkHost "gondor";
    };
  };
}
