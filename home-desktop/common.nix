{ config, pkgs, ... }:

{
  # Import common home configuration.
  imports = [ ../home-common.nix ];
  users.users.thejevans.packages = with pkgs; [
    firefox
  ];
}
