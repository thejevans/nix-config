{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./personal_workstation.nix
  ];

  options = {};

  config = {
    nixosModules = {
      gaming.enable = true;
      ld.enable = true;
    };

    services.hardware.openrgb.enable = true;
  };
}
