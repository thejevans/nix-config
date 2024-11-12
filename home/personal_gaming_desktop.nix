{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./personal_workstation.nix
  ];

  options = {};

  config = {
    homeManagerModules = {
      pipewireScarlett8i6.enable = true;
    };

    home.packages = with pkgs; [
      openrgb
    ];

    wayland.windowManager.sway.config.output = lib.mkIf config.homeManagerModules.sway.enable {
      DP-1 = {
        scale = "2";
        mode = "3840x2160@120Hz";
        pos = "4267,400";
      };
      DP-3 = {
        scale = "1.5";
        mode = "2560x2880@60Hz";
        pos = "2560,0";
      };
      DP-2 = {
        scale = "1";
        mode = "2560x1440@240Hz";
        pos = "0,240";
      };
    };
  };
}
