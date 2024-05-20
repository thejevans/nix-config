{ config, pkgs, lib, inputs, ... }: {

  imports = [];

  options = {
    homeManagerModules.hyprland.enable = lib.mkEnableOption "enables hyprland desktop environment";
  };

  config = lib.mkIf config.homeManagerModules.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      plugins = [
        inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
      ];

      settings = {
        "plugin:borders-plus-plus" = {
          add_borders = 1; # 0-9

          border_size_1 = 10;
          border_size_2 = -1;

          natural_rounding = "yes";
        };
      };
    };
  };

}
