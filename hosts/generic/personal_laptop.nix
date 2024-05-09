{ config, pkgs, lib, inputs, ... }:

{

  imports = [];

  options = {};

  config = {
    services.avahi.enable = true;

    nixosModules = {
      firefox.enable = true;
      fish.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-24.8.6" ];
    };

    environment.systemPackages = with pkgs; [
      # cli
      usbutils
      pciutils
      lshw
      wget
      git
      gnumake
      bash
      btop
      ntfs3g

      # gui
      sleek
      obsidian
    ];

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
