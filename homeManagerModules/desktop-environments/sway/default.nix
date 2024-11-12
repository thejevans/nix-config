{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./waybar.nix
    ./swaync.nix
  ];

  options = {
    homeManagerModules.sway.enable = lib.mkEnableOption "enables Sway window manager and supporting software";
  };

  config = lib.mkIf config.homeManagerModules.sway.enable {
    home.packages = with pkgs; [
      wofi
      swayosd
      khal
      wlr-randr
      wdisplays
    ];

    # Enable KDE Connect
    services.kdeconnect.enable = true;

    services.swayosd = {
      enable = true;
      topMargin = 0.95;
      stylePath = ./swayosd.css;
    };

    programs.zathura.enable = true;
    programs.ranger.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "wofi --show drun";
        gaps.inner = 10;
        bars = [];
        window = {
          titlebar = false;
          hideEdgeBorders = "smart";
        };
        startup = [
          # launch firefox on startup
          {command = "swaymsg \"workspace 1; exec firefox\"";}
          {command = lib.getExe' pkgs.swayosd "swayosd-server";}
        ];
      };
      extraConfig = ''
        input "type:touchpad" {
          dwt enabled
          tap enabled
          middle_emulation enabled
        }

        # Brightness# Control volume
        bindsym XF86AudioRaiseVolume exec 'swayosd-client --output-volume raise'
        bindsym XF86AudioLowerVolume exec 'swayosd-client --output-volume lower'
        bindsym XF86AudioMute exec 'swayosd-client --output-volume mute-toggle'
        bindsym XF86AudioMicMute exec 'swayosd-client --input-volume mute-toggle'
        # Control brightness
        bindsym XF86MonBrightnessUp exec 'swayosd-client --brightness raise'
        bindsym XF86MonBrightnessDown exec 'swayosd-client --brightness lower'
        for_window [title="nmtui-popup"] floating enable
      '';
      #  "${mod}+Control+h" = "workspace prev";
      #  "${mod}+Control+l" = "workspace next";
      #  "${mod}+Tab" = "workspace back_and_forth";
      #'';
    };
  };
}
