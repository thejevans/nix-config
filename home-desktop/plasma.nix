{ config, pkgs, ... }:

{
  # Import home-desktop/common, which imports home-common.
  imports = [ ./common.nix ];

  home.packages = with pkgs; [
    kate
    plasma-browser-integration
    element-desktop
    dolphin
  ];

  # Enable Firefox integration
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  # Enable KDE Connect
  services.kdeconnect.enable = true;
}
