{ config, pkgs, lib, home-manager, ... }: {

  imports = [];

  options = {
    homeManagerModules.pipewireScarlett8i6.enable = lib.mkEnableOption "enables Scarlett 8i6 pipewire config";
  };

  config = lib.mkIf config.homeManagerModules.pipewireScarlett8i6.enable {
    home.file.".config/pipewire/pipewire.conf.d/10-scarlett-8i6.conf".source = ./10-scarlett-8i6.conf;
  };

}
