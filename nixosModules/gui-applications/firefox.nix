{ pkgs, lib, config, ... }: {

  imports = [];

  options = {
    nixosModules.firefox.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.nixosModules.firefox.enable {
    environment.variables.MOZ_USE_XINPUT2 = "1";
  };

}
