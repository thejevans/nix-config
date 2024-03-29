{

  description = "NixOS configuration with flakes";

  inputs = {
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-cosmic, nixos-hardware, home-manager, nur, ... }: let

  nixosConfiguration = {
    system,
    host,
    user,
    fullName,
    timeZone,
    desktopEnvironment,
    homeConfig,
    stateVersion,
  }: nixpkgs.lib.nixosSystem {

    inherit system;

    specialArgs = {
      inherit homeConfig inputs host user fullName timeZone desktopEnvironment stateVersion;
    };

    modules = [
      ./hosts/${host}/configuration.nix
      ./hosts/generic/dynamic.nix
      ( ./hosts/generic + "/${homeConfig}.nix" )
      ./nixosModules

      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager {
        home-manager.extraSpecialArgs = {
          inherit inputs user desktopEnvironment stateVersion;
        };

        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.${user} = import ( ./home + "/${homeConfig}.nix" );
      }
    ];

  };
  in{

    nixosConfigurations = {

      mujina = nixosConfiguration {
        system = "x86_64-linux";
        host = "mujina";
        user = "thejevans";
        fullName = "John Evans";
        timeZone = "America/Denver";
        desktopEnvironment = "cosmic";
        homeConfig = "personal_laptop";
        stateVersion = "23.05";
      };

      kotobuki = nixosConfiguration {
        system = "x86_64-linux";
        host = "kotobuki";
        user = "thejevans";
        full-name = "John Evans";
        time-zone = "America/Denver";
        desktopEnvironment = "plasma6";
        homeConfig = "personal_laptop";
        stateVersion = "23.05";
      };

    };

    homeManagerModules.default = ./homeManagerModules;

  };

}
