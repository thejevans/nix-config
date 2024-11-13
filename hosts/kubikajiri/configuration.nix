{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  options = {};

  config = {
    services = {
      thermald.enable = true;
      power-profiles-daemon.enable = false;
      fwupd.enable = true;
      sshd.enable = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    networking.interfaces.enp6s0.wakeOnLan.enable = true;

    boot.extraModprobeConfig = ''
      options snd slots=snd-usb-audio
    '';

    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "to_couch";

        runtimeInputs = [pkgs.wlr-randr pkgs.jq];

        text = ''
          export WAYLAND_DISPLAY=wayland-1

          wlr-randr --output DP-1 --on --scale 2 --mode 3840x2160@120Hz
          wlr-randr --output DP-2 --off
          wlr-randr --output DP-3 --off

          wpctl set-default "$(pw-dump -N | jq '.[] | select(.info.props."media.class" == "Audio/Sink") | select(.info.props."node.name" == "alsa_output.pci-0000_0a_00.1.hdmi-stereo") | .info.props."object.id"')"
        '';
      })

      (pkgs.writeShellApplication {
        name = "to_desk";

        runtimeInputs = [pkgs.wlr-randr pkgs.jq];

        text = ''
          export WAYLAND_DISPLAY=wayland-1

          wlr-randr --output DP-2 --on --mode 2560x1440@239.998001Hz --scale 1 --pos "0,240"
          wlr-randr --output DP-3 --on --mode 2560x2880 --scale 1.5 --pos "2560,0"
          wlr-randr --output DP-1 --off

          wpctl set-default "$(pw-dump -N | jq '.[] | select(.info.props."media.class" == "Audio/Sink") | select(.info.props."node.name" == "scarlett_8i6_primary") | .info.props."object.id"')"
        '';
      })
    ];
  };
}
