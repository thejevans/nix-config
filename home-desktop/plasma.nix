{ config, pkgs, ... }:

{
  # Import home-desktop/common, which imports home-common.
  imports = [ ./common.nix ];

  home.packages = with pkgs; [
    kate
    plasma-browser-integration
  ];

  # Enable Firefox integration
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  programs.firefox.package = pkgs.firefox.override {
    cfg.enablePlasmaBrowserIntegration = true;
  };

  # Enable KDE Connect
  services.kdeconnect.enable = true;
}
