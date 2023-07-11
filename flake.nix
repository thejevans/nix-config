{
  description = "NixOS configuration with flakes";
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:

  {
    nixosConfigurations = {
      mujina = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./host-mujina
          nixos-hardware.nixosModules.framework-12th-gen-intel

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.thejevans = import ./home-desktop/plasma.nix;
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
