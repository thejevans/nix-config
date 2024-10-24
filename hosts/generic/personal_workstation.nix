{
  config,
  pkgs,
  ...
}: {
  imports = [];

  options = {};

  config = {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    nixosModules = {
      fish.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = ["electron-24.8.6"];
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

    services.udev.packages = [
      pkgs.platformio-core.udev
      pkgs.openocd
    ];

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = [pkgs.gutenprint pkgs.brlaser];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Enable Flatpak
    services.flatpak.enable = true;

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
        package = pkgs.nerdfonts.override {fonts = ["Hack"];};
        name = "Hack Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerdfonts.override {fonts = ["Hack"];};
        name = "Hack Nerd Font";
      };
      serif = {
        package = pkgs.nerdfonts.override {fonts = ["Tinos"];};
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
