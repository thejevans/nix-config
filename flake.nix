{

  description = "NixOS configuration with flakes";

  inputs = {
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-cosmic,
    nixos-hardware,
    home-manager,
    nur,
    ...
  }@inputs: let

  globalConfig = { pkgs, lib, ... }: {
    options.globalConfig = {
      system = lib.mkOption { type = lib.types.string; };
      stateVersion = lib.mkOption { type = lib.types.string; };
      timeZone = lib.mkOption { type = lib.types.string; };
      fullName = lib.mkOption { type = lib.types.string; };
      user = lib.mkOption { type = lib.types.string; };
      host = lib.mkOption { type = lib.types.string; };

      deviceClass = lib.mkOption {
        type = lib.types.enum [ "personal_laptop" "personal_desktop" ];
        default = "personal_laptop";
      };

      desktopEnvironment = lib.mkOption {
        type = lib.types.enum [ "plasma6" "cosmic" ];
        default = "plasma6";
      };

      gpu = lib.mkOption {
        type = lib.types.enum [ "amdgpu" "nvidia" "integrated" ];
        default = "integrated";
      };
    };
  };

  nixosConfiguration = {
    system,
    stateVersion,
    desktopEnvironment,
    timeZone,
    fullName,
    user,
    host,
    deviceClass,
    gpu,
  }: nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = { inherit inputs; };

    modules = [
      ./hosts/${host}/configuration.nix
      ./hosts/generic/global.nix
      ( ./hosts/generic + "/${deviceClass}.nix" )
      ./nixosModules

      { nixpkgs.overlays = [ nur.overlay ]; }

      {
        imports = [ globalConfig ];
        config.globalConfig = {
          inherit stateVersion timeZone fullName user host;
          inherit deviceClass desktopEnvironment gpu system;
        };
      }

      home-manager.nixosModules.home-manager {
        home-manager.extraSpecialArgs = {
          inherit inputs user desktopEnvironment stateVersion;
        };

        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.${user} = import ( ./home + "/${deviceClass}.nix" );
      }
    ];
  };

  in {

    nixosConfigurations = {

      mujina = nixosConfiguration {
        system = "x86_64-linux";
        host = "mujina";
        user = "thejevans";
        fullName = "John Evans";
        timeZone = "America/Denver";
        desktopEnvironment = "cosmic";
        deviceClass = "personal_laptop";
        stateVersion = "23.05";
        gpu = "integrated";
      };

      kotobuki = nixosConfiguration {
        system = "x86_64-linux";
        host = "kotobuki";
        user = "thejevans";
        fullName = "John Evans";
        timeZone = "America/Denver";
        desktopEnvironment = "plasma6";
        deviceClass = "personal_laptop";
        stateVersion = "23.05";
        gpu = "integrated";
      };

      kubikajiri = nixosConfiguration {
        system = "x86_64-linux";
        host = "kubikajiri";
        user = "thejevans";
        fullName = "John Evans";
        timeZone = "America/Denver";
        desktopEnvironment = "plasma6";
        deviceClass = "personal_desktop";
        stateVersion = "23.11";
        gpu = "amdgpu";
      };

    };

    homeManagerModules.default = ./homeManagerModules;

  };

}
