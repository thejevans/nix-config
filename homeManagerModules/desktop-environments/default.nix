{ pkgs, lib, config, home-manager, ... }: {

  imports = [
    ./plasma6.nix

    ./cosmic
  ];

  options = {};

  config = {};

}
