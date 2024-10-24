{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./gaming.nix
  ];

  options = {};

  config = {
    environment.systemPackages = with pkgs; [rpi-imager];
  };
}
