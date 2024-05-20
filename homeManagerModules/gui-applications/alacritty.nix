{ pkgs, lib, config, ... }:

{

  imports = [];

  options = {
    homeManagerModules.alacritty.enable = lib.mkEnableOption "enables alacritty";
  };

  config = lib.mkIf config.homeManagerModules.alacritty.enable {
    home.packages = with pkgs; [
      alacritty
    ];

    programs.alacritty = {
      enable = true;
      settings.shell.program = lib.mkIf config.homeManagerModules.fish.enable "fish";
      settings.window.decorations = "none";
      #settings.font.size = 20;
    };
  };

}
