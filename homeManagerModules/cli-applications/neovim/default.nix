{
  config,
  pkgs,
  lib,
  user,
  host,
  ...
}: let
  lua_plugin = plugin: name: {
    inherit plugin;
    type = "lua";
    config = builtins.readFile (./. + "/plugin-${name}.lua");
  };
in {
  imports = [];

  options = {
    homeManagerModules.neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.homeManagerModules.neovim.enable {
    home.packages = with pkgs; [
      tree-sitter
      nixd
      alejandra
      pyright
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      extraLuaConfig = ''
        local nvim_lsp = require("lspconfig")
        vim.opt.termguicolors = true
        nvim_lsp.nixd.setup({
           cmd = { "nixd" },
           settings = {
              nixd = {
                 nixpkgs = {
                    expr = "import <nixpkgs> { }",
                 },
                 formatting = {
                    command = { "alejandra" },
                 },
                 options = {
                    nixos = {
                       expr = '(builtins.getFlake \"github:thejevans/nixos-config\").nixosConfigurations.${host}.options',
                    },
                    home_manager = {
                       expr = '(builtins.getFlake \"github:thejevans/nixos-config\").homeConfigurations."${user}@${host}".options',
                    },
                 },
              },
           },
        })
      '';

      plugins = [
        #( lua_plugin luaPackages.lazy-nvim "lazy-nvim" )

        # color scheme
        (lua_plugin pkgs.vimPlugins.lualine-nvim "lualine-nvim")
        (lua_plugin pkgs.vimPlugins.material-nvim "material-nvim")

        # cmp dependencies
        pkgs.vimPlugins.cmp-nvim-lsp
        pkgs.vimPlugins.cmp-buffer
        pkgs.vimPlugins.cmp-path
        pkgs.vimPlugins.cmp-cmdline
        pkgs.luaPackages.luasnip
        pkgs.vimPlugins.cmp_luasnip

        # luasnip dependencies
        pkgs.luaPackages.jsregexp

        (lua_plugin pkgs.vimPlugins.nvim-cmp "nvim-cmp")

        (lua_plugin pkgs.vimPlugins.nvim-lspconfig "nvim-lspconfig")
        (lua_plugin pkgs.vimPlugins.nvim-treesitter.withAllGrammars "nvim-treesitter")
        (lua_plugin pkgs.vimPlugins.rust-tools-nvim "rust-tools-nvim")

        # telescope dependencies
        pkgs.luaPackages.plenary-nvim
        pkgs.vimPlugins.nvim-web-devicons

        (lua_plugin pkgs.vimPlugins.telescope-nvim "telescope-nvim")

        pkgs.vimPlugins.neovim-sensible
        pkgs.vimPlugins.nvim-dap
        pkgs.vimPlugins.nvim-neoclip-lua
        pkgs.vimPlugins.nvim-surround
        pkgs.vimPlugins.nvim-tree-lua
        pkgs.vimPlugins.popup-nvim
      ];
    };
  };
}
