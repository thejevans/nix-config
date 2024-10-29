{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [];

  options = {};

  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "graphical-session.target";

      settings = [
        {
          layer = "top";
          position = "top";
          exclusive = true;
          fixed-center = true;
          gtk-layer-shell = true;
          spacing = 0;
          margin-top = 7;
          margin-bottom = 0;
          margin-left = 7;
          margin-right = 7;

          modules-left = [
            "image#nixlogo"
            "sway/workspaces"
          ];

          modules-center = [
            "clock"
          ];

          modules-right = [
            "tray"
            "pulseaudio"
            "cpu"
            "memory"
            "network"
            "battery"
            "custom/notification"
          ];

          # Logo
          "custom/nixlogo" = {
            format = "";
            tooltip = false;
            on-click = "${pkgs.wofi}/bin/wofi --show drun";
          };

          "image#nixlogo" = {
            path = ./Nix_Logo.svg;
            tooltip = false;
            on-click = "${pkgs.wofi}/bin/wofi --show drun";
          };

          # Workspaces
          "hyprland/workspaces" = {
            format = "{name}";
            on-click = "activate";
            disable-scroll = true;
            all-outputs = true;
            show-special = true;
            persistent-workspaces = {"*" = 6;};
          };

          "sway/workspaces" = {
            all-outputs = true;
            disable-scroll = true;
          };

          # Clock & Calendar
          clock = {
            format = "{:%a %b %d, %H:%M}";
            on-click = "${pkgs.alacritty}/bin/alacritty --title nmtui-popup -o font.size=10 -o window.dimensions.columns=80 -o window.dimensions.lines=35 -e ${pkgs.khal}/bin/khal";

            actions = {
              on-scroll-down = "shift_down";
              on-scroll-up = "shift_up";
            };
          };

          # Tray
          tray = {
            icon-size = 15;
            show-passive-items = true;
            spacing = 8;
          };

          # Notifications
          "custom/notification" = {
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            return-type = "json";
            format = "{icon}";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
            escape = true;

            format-icons = {
              notification = "󰂚";
              none = "󰂜";
              dnd-notification = "󰂛";
              dnd-none = "󰪑";
              inhibited-notification = "󰂛";
              inhibited-none = "󰪑";
              dnd-inhibited-notification = "󰂛";
              dnd-inhibited-none = "󰪑";
            };
          };

          # Pulseaudio
          pulseaudio = {
            format = "{volume} {icon} / {format_source}";
            format-source = "󰍬";
            format-source-muted = "󰍭";
            format-muted = "󰖁 / {format_source}";
            format-icons = {default = ["󰕿" "󰖀" "󰕾"];};
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            on-scroll-up = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
            on-scroll-down = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
            tooltip = false;
          };

          # Battery
          battery = {
            format = "{icon} {capacity}%";
            format-charging = "{icon}  {capacity}%";
            format-icons = ["" "" "" "" ""];
            format-plugged = " {power} W";
            interval = 5;
            tooltip-format = "{timeTo}, {capacity}%\n {power} W";

            states = {
              warning = 30;
              critical = 15;
            };
          };

          # Cpu usage
          cpu = {
            interval = 5;
            tooltip = false;
            format = " {usage}%";
            format-alt = " {load}";
            on-click = "${pkgs.alacritty}/bin/alacritty --title nmtui-popup -o font.size=10 -o window.dimensions.columns=80 -o window.dimensions.lines=35 -e ${pkgs.btop}/bin/btop";

            states = {
              warning = 70;
              critical = 90;
            };
          };

          # Memory usage
          memory = {
            interval = 5;
            format = " {percentage}%";
            tooltip = " {used:0.1f}G/{total:0.1f}G";

            on-click = "${pkgs.alacritty}/bin/alacritty --title nmtui-popup -o font.size=10 -o window.dimensions.columns=80 -o window.dimensions.lines=35 -e ${pkgs.btop}/bin/btop";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          # Network
          network = {
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            format-wifi = "{icon}";
            format-ethernet = "󰈀"; # 󰈁
            format-disconnected = "⚠";
            tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n {bandwidthUpBytes}  {bandwidthDownBytes}";
            tooltip-format-ethernet = "Ethernet: {ifname}\n {bandwidthUpBytes}  {bandwidthDownBytes}";
            tooltip-format-disconnected = "Disconnected";
            on-click = "${pkgs.alacritty}/bin/alacritty --title nmtui-popup -o font.size=10 -o window.dimensions.columns=80 -o window.dimensions.lines=35 -e ${pkgs.networkmanager}/sbin/nmtui";
            interval = 5;
          };
        }
      ];

      style = lib.mkAfter ''
        ${builtins.readFile (./. + "/style.css")}
      '';
    };
  };
}
