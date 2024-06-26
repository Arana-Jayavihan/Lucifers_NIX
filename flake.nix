{
  description = "Lucifer's NIX";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor = {
      type = "git";
      url = "https://github.com/hyprwm/hyprcursor";
      rev = "66d5b46ff94efbfa6fa3d1d1b66735f1779c34a6";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ nixpkgs-stable, nixpkgs, home-manager, impermanence, nix-colors, spicetify-nix, ... }:
  let
    system = "x86_64-linux";
    inherit (import ./options.nix) username hostname;

    pkgs = import nixpkgs {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };

    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };

    nixColorsContrib = nix-colors.lib.contrib { inherit pkgs; };

  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
	specialArgs = { 
          inherit system; 
          inherit inputs; 
          inherit username; 
          inherit hostname;
          inherit pkgs-stable;
          inherit nixColorsContrib;
        };
	modules = [ 
          ./system.nix
	  impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager {
	    home-manager.extraSpecialArgs = {
              inherit username; 
              inherit inputs;
              inherit pkgs-stable;
              inherit nixColorsContrib;
              inherit spicetify-nix;
            };
	    home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
	    home-manager.users.${username} = import ./home.nix;
	  }
	];
      };
    };
  };
}
