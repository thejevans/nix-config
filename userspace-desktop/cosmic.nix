{ config, pkgs, ... }:

{
  # Import userspace-desktop/common, which imports userspace-common
  imports = [ ./common.nix ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.xserver.displayManager.cosmic-greeter.enable = true;
  services.xserver.desktopManager.cosmic.enable = true;
}
