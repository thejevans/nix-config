{ pkgs, lib, ... }: {

  imports = [
    ./cosmic.nix
    ./plasma6.nix
    ./hyprland.nix
  ];

  options = {};

  config = {};
}
