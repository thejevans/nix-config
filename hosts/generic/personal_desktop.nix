{ config, pkgs, lib, inputs, ... }:

{

  imports = [];

  options = {};

  config = {
    services.avahi.enable = true;

    nixosModules = {
      firefox.enable = true;
      fish.enable = true;
      gaming.enable = true;
      ld.enable = true;
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
      ntfs3g

      # gui
      vesktop
      jellyfin-media-player
      obsidian
      vlc
      ghostwriter
      newsflash
      chromium
      libreoffice

      # currently broken upstream
      #openrgb-with-all-plugins
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

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    stylix.image = ./nixos-wallpaper.png;

    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.name = "Bibata-Modern-Ice";

    stylix.polarity = "dark";

    stylix.opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    stylix.fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
        name = "Hack Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 10;
        popups = 10;
      };
    };
  };
}
