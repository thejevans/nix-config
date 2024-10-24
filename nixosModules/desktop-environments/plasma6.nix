{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [];

  options = {
    nixosModules.plasma6.enable = lib.mkEnableOption "enables KDE Plasma 6 desktop environment";
  };

  config = lib.mkIf config.nixosModules.plasma6.enable {
    environment.systemPackages = with pkgs; [
      xsettingsd
      xorg.xrdb
    ];

    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.displayManager.defaultSession = "plasma";
    services.desktopManager.plasma6.enable = true;

    # Automatically authenticate KDEWallet
    # DOESN'T WORK
    security.pam.services.kde.kwallet.enable = true;

    # Open ports for KDEConnect
    networking.firewall.allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    networking.firewall.allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    networking.firewall.allowedTCPPorts = [8010];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
