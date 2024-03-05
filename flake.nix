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

  outputs = inputs@{ self, nixpkgs, nixos-cosmic, nixos-hardware, home-manager, nur, ... }:
  {
    nixosConfigurations = {
      mujina = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./host-mujina
          nixos-hardware.nixosModules.framework-12th-gen-intel

          {
            nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [
                  "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
                ];
              };
          }

          nixos-cosmic.nixosModules.default

          { nixpkgs.overlays = [ nur.overlay ]; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.thejevans = import ./home-desktop/plasma.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

     kotobuki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./host-kotobuki
          nixos-hardware.nixosModules.apple-macbook-air-4

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.thejevans = import ./home-desktop/plasma.nix;
          }
        ];
      };

    };
  };
}
