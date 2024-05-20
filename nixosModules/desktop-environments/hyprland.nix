{ pkgs, lib, config, inputs, ... }: {

  imports = [];

  options = {
    nixosModules.hyprland.enable = lib.mkEnableOption "enables hyprland desktop environment";
  };

  config = lib.mkIf config.nixosModules.hyprland.enable {
    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

}
