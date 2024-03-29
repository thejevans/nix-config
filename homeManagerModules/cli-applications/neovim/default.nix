{ config, pkgs, lib, ... }: let

lua_plugin = plugin : name : {
  inherit plugin;
  type = "lua";
  config = builtins.readFile( ./. + "/plugin-${name}.lua" );
};

in {

  imports = [];

  options = {
    homeManagerModules.neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.homeManagerModules.neovim.enable {
    home.packages = with pkgs; [
      tree-sitter
      pyright
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        # color scheme
        ( lua_plugin lualine-nvim "lualine-nvim" )
        ( lua_plugin material-nvim "material-nvim" )

        # cmp dependencies
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        luasnip
        cmp_luasnip

        ( lua_plugin nvim-cmp "nvim-cmp" )

        ( lua_plugin nvim-lspconfig "nvim-lspconfig" )
        ( lua_plugin nvim-treesitter.withAllGrammars "nvim-treesitter" )
        ( lua_plugin rust-tools-nvim "rust-tools-nvim" )

        # telescope dependencies
        plenary-nvim
        nvim-web-devicons

        ( lua_plugin telescope-nvim "telescope-nvim" )

        neovim-sensible
        nvim-dap
        nvim-neoclip-lua
        nvim-surround
        nvim-tree-lua
        popup-nvim
      ];
    };
  };

}
