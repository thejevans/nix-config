{ pkgs, lib, config, ... }:

{

  imports = [];

  options = {
    nixosModules.gaming.enable = lib.mkEnableOption "enables gaming settings";
  };

  config = lib.mkIf config.nixosModules.gaming.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = lib.mkIf (config.globalConfig.gpu != "integrated") [ config.globalConfig.gpu ];
    hardware.nvidia.modesetting.enable = lib.mkIf (config.globalConfig.gpu == "nvidia") true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
      lutris
      heroic
      bottles
    ];

    programs.gamemode.enable = true;

    # steam launch options
    # gamemoderun %command%
    # mangohud %command%
    # gamescope %command%

    # proton GE needs to be installed imperatively using protonup

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${config.globalConfig.user}/.steam/root/compatibilitytools.d";
    };
  };

}
