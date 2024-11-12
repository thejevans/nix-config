{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  options = {};

  config = {
    services.thermald.enable = true;
    services.power-profiles-daemon.enable = false;
    services.fwupd.enable = true;
    services.sshd.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    networking.interfaces.enp6s0.wakeOnLan.enable = true;

    boot.extraModprobeConfig = ''
      options snd slots=snd-usb-audio
    '';
  };
}
