{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [];

  options = {
    nixosModules.gaming.enable = lib.mkEnableOption "enables gaming settings";
  };

  config = lib.mkIf config.nixosModules.gaming.enable {
    hardware = {
      nvidia.modesetting.enable = lib.mkIf (config.globalConfig.gpu == "nvidia") true;

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    services = {
      xserver.videoDrivers = lib.mkIf (config.globalConfig.gpu != "integrated") [config.globalConfig.gpu];

      avahi.publish = {
        enable = true;
        userServices = true;
      };

      pipewire.extraConfig.pipewire."92-low-latency".context.properties.default.clock = {
        rate = 48000;
        quantum = 32;
        min-quantum = 32;
        max-quantum = 32;
      };
    };

    programs = {
      gamemode.enable = true;

      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
      lutris
      heroic
      bottles
      ryujinx

      # game streaming
      sunshine
      moonlight-qt
    ];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };

    # sunshine networking settings
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [47984 47989 47990 48010];
      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48000;
        }
        #{ from = 8000; to = 8010; }
      ];
    };

    systemd.user.services.sunshine = {
      description = "Sunshine self-hosted game stream host for Moonlight";
      startLimitBurst = 5;
      startLimitIntervalSec = 500;
      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

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
