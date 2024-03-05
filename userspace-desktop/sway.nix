{ config, pkgs, ... }:

{
  # Import userspace-desktop/common, which imports userspace-common
  imports = [ ./common.nix ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    #package = (pkgs.mesa.override { galliumDrivers = [ "i915" "swrast" ]; }).drivers;
  };

  users.users.thejevans.extraGroups = [ "video" ];
  programs.light.enable = true;

  security.polkit.enable = true;
  security.pam.services.greetd.enableKwallet = true;

  programs.sway.enable = true;
  programs.sway.package = null;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "thejevans";
      };
      default_session = initial_session;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    polkit-kde-agent
    plasma5Packages.kwallet
    kwallet-pam
    kwalletcli
    kwalletmanager
  ];
}
