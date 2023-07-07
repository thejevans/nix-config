{ config, pkgs, ... }:

{
  # Import home-desktop/common, which imports home-common.
  imports = [ ./common.nix ];

  users.users.thejevans.packages = with pkgs; [
    kate
    plasma-browser-integration
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable Firefox integration
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
