{ config, pkgs, lib, inputs, ... }:

{

  imports = [];

  options = {};

  config = {
    services.avahi.enable = true;

    nixosModules = {
      fish.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-24.8.6" ];
    };

    environment.systemPackages = with pkgs; [
      usbutils
      pciutils
      lshw
      wget
      git
      gnumake
      bash
      ntfs3g
    ];

    # Enable networking
    networking.networkmanager.enable = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };
}
