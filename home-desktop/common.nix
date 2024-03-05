{ config, pkgs, nur, ... }:

{
  # Import common home configuration.
  imports = [
    ../home-common.nix
    ../home-application/cachix.nix
    ../home-application/firefox
  ];

  home.packages = with pkgs; [
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
