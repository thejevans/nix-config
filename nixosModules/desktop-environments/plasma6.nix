{ pkgs, lib, config, ... }: {

  imports = [];

  options = {
    nixosModules.plasma6.enable = lib.mkEnableOption "enables KDE Plasma 6 desktop environment";
  };

  config = lib.mkIf config.nixosModules.plasma6.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.wayland.enable = true;
    services.xserver.displayManager.defaultSession = "plasma";
    services.xserver.desktopManager.plasma6.enable = true;

    # Automatically authenticate KDEWallet
    # DOESN'T WORK
    # security.pam.services.login.enableKwallet = true;

    # Open ports for KDEConnect
    networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedTCPPorts = [ 8010 ];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };

}
