{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withRuby = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      barbar-nvim
      cmp-nvim-lsp
      cmp_luasnip
      dracula-nvim
      friendly-snippets
      luasnip
      neotest
      neotest-go
      nvim-cmp
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-lspconfig
      nvim-nio
      nvim-tree-lua
      nvim-web-devicons
      plenary-nvim
      toggleterm-nvim
      ultisnips
      vim-lsp-snippets
      vim-lsp-ultisnips
      vim-puppet
      vim-sleuth
      vim-snippets
      vimtex
    ] ++ (builtins.concatMap (language: with pkgs.vimPlugins.nvim-treesitter; [
      # Neovim handles highlighting; install parsers and queries without a runtime installer.
      grammarPlugins.${language}
      queries.${language}
    ]) [ "go" "gomod" "gosum" "gowork" ]);
    extraPackages = with pkgs; [
      go
      gopls
      delve
      nil
      phpactor
      rust-analyzer
      texlab
      pyright
    ];
    extraConfig = ''
      let g:vimtex_view_general_viewer = 'okular'
      let g:vimtex_syntax_enabled = 0
      let maplocalleader = ","
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set encoding=utf-8
    '';
    initLua = ''
      require('configuration').setup()
    '';
  };

  xdg.configFile."nvim/lua" = {
    source = ./neovim;
    recursive = true;
  };
}
