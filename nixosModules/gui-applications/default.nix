{ pkgs, lib, ... }: {

  imports = [
    ./firefox.nix
    ./gaming.nix
  ];

  options = {};

  config = {};
}
