{ pkgs, lib, config, home-manager, ... }: {

  imports = [
    ./gui-applications
    ./cli-applications
    ./desktop-environments
  ];

  options = {};

  config = {};

}
