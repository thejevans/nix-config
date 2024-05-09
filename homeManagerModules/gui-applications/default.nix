{ pkgs, lib, config, home-manager, ... }: {

  imports = [
    ./alacritty.nix

    ./firefox
  ];

  options = {};

  config = {};

}
