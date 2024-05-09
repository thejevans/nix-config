{ pkgs, lib, config, ... }:

{

  imports = [];

  options = {
    homeManagerModules.fish.enable = lib.mkEnableOption "enables fish";
  };

  config = lib.mkIf config.homeManagerModules.fish.enable {
    home.packages = with pkgs; [
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      fishPlugins.grc
      grc
      pfetch
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
            pfetch
        end
      '';
    };
  };

}
