{ config, inputs, pkgs, lib, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		extraLuaConfig = builtins.readFile ./init.lua;
		extraLuaPackages = luaPkgs: with luaPkgs; [];
		extraPackages = [
			pkgs.ripgrep

			# Language servers
			pkgs.nil
			pkgs.nixd
			pkgs.lua-language-server
			pkgs.rust-analyzer
			pkgs.fish-lsp
		];
		plugins = with pkgs.vimPlugins; [
			# Important backend
			nvim-lspconfig
			nvim-cmp
			cmp-nvim-lsp
			cmp_luasnip
			luasnip

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

            # Themes
            catppuccin-nvim
		];
	};
	xdg.configFile = {
		# "nvim/snippets".source = ./snippets;
		# "nvim/after/ftplugins".source = ./after/ftplugin;
		"nvim/lua".source = ./lua;
		# "nvim/ftplugin".source = ./ftplugin;
	};
}
