{ pkgs, lib, config, home-manager, ... }: {

  imports = [
    ./plasma6.nix
    ./cosmic
    ./sway
  ];

  options = {};

  config = {};

}
