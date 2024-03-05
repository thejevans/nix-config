{ config, pkgs, lib, nur, ... }:

{
  # Import home-desktop/common, which imports home-common.
  imports = [ ./common.nix ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.config = rec {
    modifier = "Mod4";

    keybindings = let
      modifier = config.wayland.windowManager.sway.config.modifier;
    in lib.mkOptionDefault {
      "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      # Brightness
      "XF86MonBrightnessDown" = "exec light -U 10";
      "XF86MonBrightnessUp" = "exec light -A 10";

      # Volume
      "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
      "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
      "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
    };

    # Use foot as default terminal
    terminal = "foot"; 
    startup = [
      # Launch Firefox on start
      {command = "firefox";}
    ];

    fonts = {
      names = [ "Hack Mono" ];
      style = "Bold Semi-Condensed";
      size = 11.0;
    };

    gaps = {
      inner = 0;
      outer = 0;
    };

    window = {
      titlebar = false;
      hideEdgeBorders = "smart";
    };

    input = {
      "type:touchpad" = {
        click_method = "clickfinger";
        tap = "enabled";
      };

      "type:keyboard" = {
        xkb_options = "caps:swapescape";
      };
    };
  };

  #output.DP-1.scale = 1.5;

  wayland.windowManager.sway.extraConfigEarly = ''
    exec store=(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}') /nix/store/$store/libexec/polkit-kde-authentication-agent-1 &
    exec dbus-update-activation-environment WAYLAND_DISPLAY &
  '';

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    element-desktop
    dolphin
    foot
    libinput
    networkmanager
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
  ];
}
