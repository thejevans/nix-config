{ config, pkgs, ... }:

{
  # Import common home configuration.
  imports = [
    ../home-common.nix
    ../home-application/cachix.nix
  ];
  home.packages = with pkgs; [
    firefox
    alacritty
    darktable
    webcord
    hydroxide
    obsidian
    nextcloud-client

    # devenv
    cachix
  ];

  programs.alacritty = {
    enable = true;
    settings.shell.program = "fish";
  };
}
