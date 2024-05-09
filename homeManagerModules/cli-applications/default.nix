{ pkgs, lib, config, ... }: {

  imports = [
    ./starship.nix
    ./fish.nix

    ./cachix
    ./neovim
  ];

  options = {};

  config = {};

}
