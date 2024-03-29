{ inputs, host, user, fullName, timeZone, desktopEnvironment, stateVersion, pkgs, ... }: {

  imports = [];

  options = {};

  config = {
    time.timeZone = "${timeZone}";

    networking.hostName = "${host}"             ;

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
    users.users."${user}" = {
      isNormalUser = true;
      description = "${fullName}";
      home = "/home/${user}";
      group = "${user}";
      extraGroups = [ "networkmanager" "wheel" "uinput" ];
    };

    nixosModules.${desktopEnvironment}.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "${stateVersion}"; # Did you read the comment?

    users.groups.${user} = {};

    # Enable flakes.
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
      vim
      home-manager
    ];
  };
}
