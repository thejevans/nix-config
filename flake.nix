{
  description = "NixOS configuration with flakes";
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.05";
  };

  outputs = { self, nixpkgs, nixos-hardware }: let
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
        ];
      };
    };
  };
}
