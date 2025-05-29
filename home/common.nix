{ config, pkgs, lib, inputs, ... }:

{
	home.username = "brams";
	home.stateVersion = "24.11";
	fonts.fontconfig.enable = true;

	home.packages = [
		pkgs.manix
		pkgs.xsel
		pkgs.strawberry
	];

	imports = [
		# Shell apps
		./terminal/shell/fish.nix

		# Terminal apps
		./terminal/apps/jujutsu.nix
		./terminal/apps/tmux.nix
		./terminal/apps/zoxide.nix
		./terminal/apps/atuin.nix
	
		# Neovim
		./terminal/neovim
		
		# Music apps
		
		# Miscellanious apps
	];

}
