{ pkgs, lib, config, home-manager, ... }: {

  imports = [
    ./plasma6.nix
    ./hyprland.nix

    ./cosmic
  ];

  options = {};

  config = {};

}
