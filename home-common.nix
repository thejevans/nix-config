{ config, pkgs, home-manager, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thejevans";
  home.homeDirectory = "/home/thejevans";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  imports = [
    ./home-application/neovim
    ./home-application/starship.nix
  ];

  home.packages = with pkgs; [
    github-cli
    gcc
    zig
    nodejs
    xclip
    ripgrep
    fd
    pfetch
    sqlite

    # fish plugins
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
          pfetch
      end
    '';
  };
}
