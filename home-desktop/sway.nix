{ config, pkgs, lib, ... }:

{
  # Import home-desktop/common, which imports home-common.
  imports = [ ./common.nix ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
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
    };
  };


  home.packages = with pkgs; [
    element-desktop
    dolphin
    foot
  ];
}
