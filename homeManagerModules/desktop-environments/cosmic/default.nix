{ config, pkgs, lib, home-manager, ... }: {

  imports = [];

  options = {
    homeManagerModules.cosmic.enable = lib.mkEnableOption "enables COSMIC desktop environment";
  };

  config = lib.mkIf config.homeManagerModules.cosmic.enable {
    home.file.".config/cosmic-comp/config.ron".source = ./config.ron;
  };

}
