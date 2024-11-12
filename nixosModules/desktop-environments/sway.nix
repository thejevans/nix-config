{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [];

  options = {
    nixosModules.sway.enable = lib.mkEnableOption "enables Sway window manager + supporting software";
  };

  config = lib.mkIf config.nixosModules.sway.enable {
    environment.systemPackages = with pkgs; [
      grim # screenshots
      slurp # screenshots
      wl-clipboard # copy and paste
      mako # notifications
      pulseaudio #needed for pactl
      polkit_gnome # for elevating GUI apps
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

    # keyring
    services.gnome.gnome-keyring.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    # kanshi systemd service
    #systemd.user.services.kanshi = {
    #  description = "kanshi daemon";
    #  environment = {
    #    WAYLAND_DISPLAY = "wayland-1";
    #    DISPLAY = ":0";
    #  };
    #  serviceConfig = {
    #    Type = "simple";
    #    ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    #  };
    #};

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        };
      };
    };

    # systemd.user.services.polkit-gnome-authentication-agent-1 = {
    #   description = "polkit-gnome-authentication-agent-1";
    #   wantedBy = ["graphical-session.target"];
    #   wants = ["graphical-session.target"];
    #   after = ["graphical-session.target"];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
    # backlight control
    # programs.light.enable = true;

    security.polkit.enable = true;

    users.users.${config.globalConfig.user}.extraGroups = ["video"];
  };
}
