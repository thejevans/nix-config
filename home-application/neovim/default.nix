{ config, pkgs, ... }: let

lua_plugin = plugin : name : {
  inherit plugin;
  type = "lua";
  config = builtins.readFile( ./. + "/plugin-${name}.lua" );
};

in {
  home.packages = with pkgs; [
    tree-sitter
    pyright
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # color scheme
      gruvbox-material
      #doom-one-nvim # don't know the actual name

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
      #nvim-neoclip # don't know the actual name
      nvim-surround
      #nvim-tree # don't know the actual name
      popup-nvim
    ];
  };
}
