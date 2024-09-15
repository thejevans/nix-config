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

      extraLuaConfig = ''
        vim.opt.termguicolors = true
      '';

      plugins = with pkgs; [
        #( lua_plugin luaPackages.lazy-nvim "lazy-nvim" )

        # color scheme
        ( lua_plugin vimPlugins.lualine-nvim "lualine-nvim" )
        ( lua_plugin vimPlugins.material-nvim "material-nvim" )

        # cmp dependencies
        vimPlugins.cmp-nvim-lsp
        vimPlugins.cmp-buffer
        vimPlugins.cmp-path
        vimPlugins.cmp-cmdline
        luaPackages.luasnip
        vimPlugins.cmp_luasnip

        # luasnip dependencies
        luaPackages.jsregexp

        ( lua_plugin vimPlugins.nvim-cmp "nvim-cmp" )

        ( lua_plugin vimPlugins.nvim-lspconfig "nvim-lspconfig" )
        ( lua_plugin vimPlugins.nvim-treesitter.withAllGrammars "nvim-treesitter" )
        ( lua_plugin vimPlugins.rust-tools-nvim "rust-tools-nvim" )

        # telescope dependencies
        luaPackages.plenary-nvim
        vimPlugins.nvim-web-devicons

        ( lua_plugin vimPlugins.telescope-nvim "telescope-nvim" )

        vimPlugins.neovim-sensible
        vimPlugins.nvim-dap
        vimPlugins.nvim-neoclip-lua
        vimPlugins.nvim-surround
        vimPlugins.nvim-tree-lua
        vimPlugins.popup-nvim
      ];
    };
  };

}
