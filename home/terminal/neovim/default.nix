{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    extraLuaPackages = luaPkgs: with luaPkgs; [ ];
    extraPackages = [
      pkgs.ripgrep

      # Language servers
      pkgs.nil
      pkgs.nixd
      pkgs.lua-language-server
      pkgs.rust-analyzer
      pkgs.fish-lsp

      # Formatters
      pkgs.ruff
      pkgs.rustfmt
      pkgs.stylua
      pkgs.prettierd
      pkgs.nixfmt-classic

      # Linters
      pkgs.pyright
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

      # Themes
      catppuccin-nvim
    ];
  };
  xdg.configFile = {
    # "nvim/snippets".source = ./snippets;
    "nvim/after/ftplugins".source = ./after/ftplugin;
    "nvim/lua".source = ./lua;
    "nvim/ftplugin".source = ./ftplugin;
  };
}
