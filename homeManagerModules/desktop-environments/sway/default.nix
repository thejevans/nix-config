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
      grim
      slurp
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
        terminal = lib.getExe pkgs.alacritty;
        menu = lib.getExe pkgs.wofi + " --show drun";
        gaps.inner = 10;
        bars = [];

        window = {
          titlebar = false;
          hideEdgeBorders = "smart";
        };

        startup = [
          # launch firefox on startup
          {command = lib.getExe' pkgs.sway "swaymsg" + " \"workspace 1; exec " + lib.getExe pkgs.firefox + "\"";}
          {command = lib.getExe' pkgs.swayosd "swayosd-server";}
        ];

        input."type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          middle_emulation = "enabled";
        };

        keybindings = let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
          lib.mkOptionDefault {
            # Screenshot utility
            "${mod}+p" = "exec " + lib.getExe pkgs.grim + " -g \"$(" + lib.getExe pkgs.slurp + ")\" - | tee \"$HOME/Pictures/Screenshots\"/\"Screenshot_$(date +%Y%m%d-%H%M%S).png\" | " + lib.getExe' pkgs.wl-clipboard "wl-copy";

            # Control volume
            "XF86AudioRaiseVolume" = "exec '" + lib.getExe' pkgs.swayosd "swayosd-client" + " --output-volume raise'";
            "XF86AudioLowerVolume" = "exec '" + lib.getExe' pkgs.swayosd "swayosd-client" + " --output-volume lower'";
            "XF86AudioMute" = "exec '" + lib.getExe' pkgs.swayosd "swayosd-client" + " --output-volume mute-toggle'";
            "XF86AudioMicMute" = "exec '" + lib.getExe' pkgs.swayosd "swayosd-client" + " --input-volume mute-toggle'";

            # Control brightness
            "XF86MonBrightnessUp" = "exec '" + lib.getExe' pkgs.swayosd "swayosd-client" + " --brightness raise'";
            "XF86MonBrightnessDown" = "exec '" + lib.getExe' pkgs.swayosd "swayosd-client" + " --brightness lower'";

            # Examples
            #  "${mod}+Control+h" = "workspace prev";
            #  "${mod}+Control+l" = "workspace next";
            #  "${mod}+Tab" = "workspace back_and_forth";
          };
      };
    };
  };
}
