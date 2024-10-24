{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [];

  options = {
    homeManagerModules.plasma6.enable = lib.mkEnableOption "enables KDE Plasma 6 desktop environment";
  };

  config = lib.mkIf config.homeManagerModules.plasma6.enable {
    home.packages = with pkgs; [
      kate
      plasma-browser-integration
      dolphin
    ];

    # Enable Firefox integration
    nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
    home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

    # Enable KDE Connect
    services.kdeconnect.enable = true;
  };
}
