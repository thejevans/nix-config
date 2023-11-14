{ config, pkgs, ... }:

{
  # Import userspace-desktop/common, which imports userspace-common
  imports = [ ./common.nix ];

  users.users.yourusername.extraGroups = [ "video" ];
  programs.light.enable = true;

  security.polkit.enable = true;
}
