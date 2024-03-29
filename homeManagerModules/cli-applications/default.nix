{ pkgs, lib, config, ... }: {

  imports = [
    ./starship.nix

    ./cachix
    ./neovim
  ];

  options = {};

  config = {};

}
