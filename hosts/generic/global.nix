{ pkgs, config, ... }: {

  imports = [];

  options = {};

  config = {
    time.timeZone = "${config.globalConfig.timeZone}";

    networking.hostName = "${config.globalConfig.host}";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."${config.globalConfig.user}" = {
      isNormalUser = true;
      description = "${config.globalConfig.fullName}";
      home = "/home/${config.globalConfig.user}";
      group = "${config.globalConfig.user}";
      extraGroups = [ "networkmanager" "wheel" "uinput" ];
    };

    nixosModules.${config.globalConfig.desktopEnvironment}.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "${config.globalConfig.stateVersion}"; # Did you read the comment?

    users.groups.${config.globalConfig.user} = {};

    # Enable flakes.
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.sessionVariables.FLAKE = "/home/${config.globalConfig.user}/git_repos/nix-config";

    nix.settings.trusted-substituters = [
      "https://cache.nixos.org/"
      "https://cosmic.cachix.org/"
      "https://devenv.cachix.org/"
    ];

    environment.systemPackages = with pkgs; [
      vim
      home-manager
      nh
    ];
  };
}
