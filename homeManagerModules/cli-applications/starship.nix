{config, pkgs, lib, home-manager, ... }: {

  imports = [];

  options = {
    homeManagerModules.starship.enable = lib.mkEnableOption "enables starship";
  };

  config = lib.mkIf config.homeManagerModules.starship.enable {
    programs.starship.enable = true;
    programs.starship.settings = {
      add_newline = false;
      format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";

      shlvl = {
        disabled = false;
        symbol = "󰹹";
        style = "bright-red bold";
      };

      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[󱆃](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };

      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };

      hostname = {
        style = "bright-green bold";
        ssh_only = true;
      };

      nix_shell = {
        symbol = "󱄅";
        format = "[$symbol $name]($style) ";
        style = "bright-purple bold";
      };

      git_branch = {
        only_attached = true;
        format = "[$symbol $branch]($style) ";
        symbol = "";
        style = "bright-yellow bold";
      };

      git_commit = {
        only_detached = true;
        format = "[$symbol $hash]($style) ";
        symbol = "";
        style = "bright-yellow bold";
      };

      git_state.style = "bright-purple bold";
      git_status.style = "bright-green bold";

      directory = {
        read_only = " ";
        truncation_length = 0;
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bright-blue";
      };

      jobs.style = "bright-green bold";

      character = {
        success_symbol = "[](bright-green bold)";
        error_symbol = "[](bright-red bold)";
      };
    };
  };

}

