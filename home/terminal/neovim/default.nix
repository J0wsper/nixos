{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    extraLuaPackages = luaPkgs: with luaPkgs; [ ];
    extraPackages = with pkgs; [
      ripgrep

      # Language servers
      nil
      nixd
      lua-language-server
      rust-analyzer
      fish-lsp
      clang
      clang-tools
      python312Packages.python-lsp-server
      marksman

      # Formatters
      ruff
      rustfmt
      stylua
      prettierd
      nixfmt-classic

      # Linters
      pyright
      markdownlint-cli
    ];
    plugins = with pkgs.vimPlugins; [
      # Important backend
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      conform-nvim

      # QoL plugins
      leap-nvim
      telescope-nvim
      comment-nvim
      dropbar-nvim
      which-key-nvim
      gitsigns-nvim
      noice-nvim
      trouble-nvim
      lualine-nvim
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      leap-nvim
      nvim-surround
      clangd_extensions-nvim

      # Themes
      catppuccin-nvim
    ];
  };
  xdg.configFile = {
    # "nvim/snippets".source = ./snippets;
    # "nvim/after/ftplugins".source = ./after/ftplugin;
    "nvim/lua".source = ./lua;
    "nvim/ftplugin".source = ./ftplugin;
  };
}
