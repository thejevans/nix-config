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
      wl-clipboard-rs
      ripgrep
      fd
      sqlite
      btop

      # gui
      darktable
      hydroxide
      obsidian
      nextcloud-client
      vesktop
      jellyfin-media-player
      vlc
      ghostwriter
      newsflash
      chromium
      libreoffice
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      pinta

      # devenv
      cachix
    ];
  };

}
