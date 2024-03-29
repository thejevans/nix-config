{ inputs, user, pkgs, lib, config, ... }: {

  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
  ];

  options = {};

  config = {};
}
