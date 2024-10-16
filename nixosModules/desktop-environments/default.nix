{ pkgs, lib, ... }: {

  imports = [
    ./cosmic.nix
    ./plasma6.nix
    ./sway.nix
  ];

  options = {};

  config = {};
}
