{
  config,
  pkgs,
  ...
}: {
  imports = [];

  options = {};

  config = {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        usbutils
        pciutils
        lshw
        wget
        git
        gnumake
        bash
        ntfs3g
      ];
    };

    nixosModules = {
      fish.enable = true;
      neovim.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = ["electron-24.8.6"];
    };

    services = {
      udev.packages = with pkgs; [
        platformio-core.udev
        openocd
      ];

      # Enable CUPS to print documents.
      printing = {
        enable = true;
        drivers = [pkgs.gutenprint pkgs.brlaser];
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      # Enable Flatpak
      flatpak.enable = true;

      # Enable sound with pipewire.
      pipewire = {
        enable = true;
        pulse.enable = true;

        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };

    # Enable networking
    networking = {
      wireless.iwd = {
        enable = true;
        settings = {
          IPv6.Enabled = true;
          Settings.AutoConnect = true;
        };
      };

      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Bootloader.
    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${config.globalConfig.user}/git_repos/nix-config";
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      image = ./nixos-wallpaper.png;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 20;
      };

      polarity = "dark";

      opacity = {
        applications = 1.0;
        terminal = 1.0;
        desktop = 1.0;
        popups = 1.0;
      };

      fonts = {
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
  };
}
