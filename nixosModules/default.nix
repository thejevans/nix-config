{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./desktop-environments
    ./gui-applications
    ./cli-applications
  ];

  options = {};

  config = {};
}
