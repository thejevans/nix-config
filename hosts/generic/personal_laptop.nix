{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./personal_workstation.nix
  ];

  options = {};

  config = {};
}
