{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./personal_workstation.nix
  ];

  options = {};

  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply" ATTR{status}=="Discharging", ATTR{capacity}=="[0-5]", RUN+="${pkgs.systemd}/bin/systemctl hibernate"
    '';
  };
}
