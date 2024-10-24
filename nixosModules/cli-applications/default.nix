{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./fish.nix
    ./neovim.nix
    ./ld.nix
  ];

  options = {};

  config = {};
}
