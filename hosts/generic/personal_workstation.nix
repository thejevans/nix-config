{ config, pkgs, lib, inputs, ... }:

{

  imports = [];

  options = {};

  config = {
    boot.initrd.systemd.enable = true;
    boot.swraid.enable = false;

    services.zfs.trim.enable = true;
    services.zfs.autoScrub.enable = true;

    boot.initrd.systemd.services.rollback = {
      description = "";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "zfs-import-rpool.service"
      ];
      before = [
        "sysroot.mount"
      ];
      path = with pkgs; [
        zfs
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        zfs rollback -r rpool/local/root@blank && echo "  >> >> rollback complete << <<"
      '';
    };

    fileSystems = {
      "/cache".neededForBoot = true;
      "/persistent".neededForBoot = true;
    };

    networking.hostId = builtins.substring 0 8 (
      builtins.hashString "sha256" config.networking.hostName
    );

    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh/authorized_keys.d"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/upower"
        "/var/log"
      ];
      files = [
        "/etc/adjtime"
        "/etc/machine-id"
        "/etc/zfs/zpool.cache"
      ];
    };

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

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
    boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    stylix.image = ./nixos-wallpaper.png;

    stylix.cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
    };

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
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
        name = "Hack Nerd Font";
      };
      serif = {
        package = pkgs.nerdfonts.override { fonts = [ "Tinos" ]; };
        name = "Tinos Nerd Font";
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
