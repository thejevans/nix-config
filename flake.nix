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

  outputs = { self, nixpkgs, nixos-hardware, home-manager }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    nixosConfigurations = {
      mujina = nixpkgs.lib.nixosSystem {
        inherit pkgs system;

        modules = [
          ./host-mujina
          # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          nixos-hardware.nixosModules.framework-12th-gen-intel

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
