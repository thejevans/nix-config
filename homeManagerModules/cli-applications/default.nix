{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./starship.nix
    ./fish.nix

    ./cachix
    ./neovim
    ./pipewire
  ];

  options = {};

  config = {};
}
