{ inputs, pkgs, ... }: {

  imports = [
    ./global.nix
    inputs.self.outputs.homeManagerModules.default
  ];

  options = {};

  config = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    homeManagerModules = {
      # gui
      firefox.enable = true;
      alacritty.enable = true;

      # cli
      neovim.enable = true;
      starship.enable = true;
      fish.enable = true;
    };

    home.packages = with pkgs; [
      # cli
      github-cli
      gcc
      zig
      nodejs
      xclip
      ripgrep
      fd
      sqlite

      # gui
      darktable
      webcord
      hydroxide
      obsidian
      nextcloud-client

      # devenv
      cachix
    ];
  };

}
