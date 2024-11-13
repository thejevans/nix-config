{
  pkgs,
  lib,
  config,
  ...
}: {
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

      settings = {
        shell.program = lib.mkIf config.homeManagerModules.fish.enable "fish";

        window = {
          decorations = "none";

          padding = {
            x = 5;
            y = 2;
          };
        };
      };
    };
  };
}
