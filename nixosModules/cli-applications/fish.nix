{ pkgs, lib, config, ... }: {

  imports = [];

  options = {
    nixosModules.fish.enable = lib.mkEnableOption "enables fish";
  };

  config = lib.mkIf config.nixosModules.firefox.enable {
    users.users.${config.globalConfig.user}.shell = pkgs.fish;
    programs.fish.enable = true;
  };

}
