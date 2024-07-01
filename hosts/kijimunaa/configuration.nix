{ inputs, config, pkgs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  options = {};

  config = {
    singleDiskZfsImpermanenceDisko = {
      enable = true;
      device = "/dev/vba";
    };
  };

}
