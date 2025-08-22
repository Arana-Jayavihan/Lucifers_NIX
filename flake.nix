{
  description = "Lucifer's NIX";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-colors.url = "github:misterio77/nix-colors";
    ags.url = "github:/Aylur/ags/v1";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      type = "git";
      url = "https://github.com/Arana-Jayavihan/spicetify-nix.git";
      #rev = "834c8f9bb8a7b63ba242f9ce0db81708c620f2bc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #firefox = {
    #  type = "git";
    #  url = "https://github.com/nix-community/flake-firefox-nightly.git";
    #   rev = "d20be2e9c1b201e4253e79a200f0a2ed7fc27441";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ 
    nixpkgs-unstable, 
    nixpkgs, 
    home-manager, 
    impermanence, 
    nix-colors, 
    spicetify-nix, 
    #firefox, 
    ... }:
  let
    system = "x86_64-linux";
    inherit (import ./options.nix) username hostname;

    pkgs = import nixpkgs {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };

    pkgs-unstable = import nixpkgs-unstable {
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
          inherit pkgs-unstable;
          inherit nixColorsContrib;
          #inherit firefox;
        };
	modules = [ 
          ./system.nix
	  impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager {
	    home-manager.extraSpecialArgs = {
              inherit username; 
              inherit inputs;
              inherit pkgs-unstable;
              inherit nixColorsContrib;
              inherit spicetify-nix;
              #inherit firefox;
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
