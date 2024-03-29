{ inputs, pkgs, ... }: {

  imports = [
    ./dynamic.nix
    inputs.self.outputs.homeManagerModules.default
  ];

  options = {};

  config = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    homeManagerModules = {
      firefox.enable = true;
      neovim.enable = true;
      starship.enable = true;
    };

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

      alacritty
      darktable
      webcord
      hydroxide
      obsidian
      nextcloud-client
      # devenv
      cachix
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
            pfetch
        end
      '';
    };

    programs.alacritty = {
      enable = true;
      settings.shell.program = "fish";
      settings.window.decorations = "none";
    };
  };

}
