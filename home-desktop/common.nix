{ config, pkgs, ... }:

{
  # Import common home configuration.
  imports = [ ../home-common.nix ];
  home.packages = with pkgs; [
    firefox
    alacritty
    darktable
    webcord
    hydroxide
  ];

}
