{
  description = "NixOS configuration with flakes";
  inputs = {
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, nur, ... }:
  {
    nixosConfigurations = {
      mujina = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./host-mujina
          nixos-hardware.nixosModules.framework-12th-gen-intel


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
