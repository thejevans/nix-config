{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # nix user repository. used for firefox config
    nur.url = "github:nix-community/NUR";

    # contains premade configurations for laptop hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # for patching dynamically loaded libraries
    nix-alien.url = "github:thiagokokada/nix-alien";

    # helps to keep colors and themes consistent across apps
    stylix.url = "github:danth/stylix/cf8b6e2d4e8aca8ef14b839a906ab5eb98b08561";

    # adds functionality to have ephemeral root
    impermanence.url = "github:nix-community/impermanence";

    # for building filesystem from configuration
    disko.url = "github:nix-community/disko";

    # for managing userspace environment
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # temporary repo for cosmic de while it's in alpha
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # adds command-not-found
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
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
    impermanence,
    disko,
    ...
  } @ inputs: let
    globalConfig = {
      pkgs,
      lib,
      ...
    }: {
      options.globalConfig = {
        system = lib.mkOption {type = lib.types.str;};
        stateVersion = lib.mkOption {type = lib.types.str;};
        timeZone = lib.mkOption {type = lib.types.str;};
        fullName = lib.mkOption {type = lib.types.str;};
        user = lib.mkOption {type = lib.types.str;};
        host = lib.mkOption {type = lib.types.str;};

        deviceClass = lib.mkOption {
          type = lib.types.enum ["personal_laptop" "personal_desktop"];
          default = "personal_laptop";
        };

        desktopEnvironment = lib.mkOption {
          type = lib.types.enum ["plasma6" "cosmic" "sway"];
          default = "plasma6";
        };

        gpu = lib.mkOption {
          type = lib.types.enum ["amdgpu" "nvidia" "integrated"];
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
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/${host}/configuration.nix
          ./hosts/generic/global.nix
          (./hosts/generic + "/${deviceClass}.nix")
          ./nixosModules
          inputs.stylix.nixosModules.stylix
          inputs.impermanence.nixosModules.impermanence
          inputs.disko.nixosModules.disko
          inputs.flake-programs-sqlite.nixosModules.programs-sqlite

          {nixpkgs.overlays = [nur.overlay];}

          {
            imports = [globalConfig];
            config.globalConfig = {
              inherit stateVersion timeZone fullName user host;
              inherit deviceClass desktopEnvironment gpu system;
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs user desktopEnvironment stateVersion host;
              };

              useUserPackages = true;
              useGlobalPkgs = true;
              users.${user} = import (./home + "/${deviceClass}.nix");
              backupFileExtension = "backup";
            };
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
        desktopEnvironment = "sway";
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
        desktopEnvironment = "sway";
        deviceClass = "personal_gaming_desktop";
        stateVersion = "23.11";
        gpu = "amdgpu";
      };
    };

    homeManagerModules.default = ./homeManagerModules;
  };
}
