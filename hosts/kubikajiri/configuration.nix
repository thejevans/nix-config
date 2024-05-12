{ pkgs, lib, inputs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  options = {};

  config = {
    services.thermald.enable = true;
    services.power-profiles-daemon.enable = false;
    services.fwupd.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
