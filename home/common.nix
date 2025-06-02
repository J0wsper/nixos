{ config, pkgs, lib, inputs, ... }:

{
	home.username = "brams";
	home.stateVersion = "24.11";
	fonts.fontconfig.enable = true;

    nix.registry.n.flake = inputs.nixpkgs;

	home.packages = [
		pkgs.manix
		pkgs.xsel
		pkgs.strawberry
        pkgs.webex
	];

	imports = [
		# Shell apps
		./terminal/shell/fish.nix

		# Terminal apps
		./terminal/apps/jujutsu.nix
		./terminal/apps/tmux.nix
		./terminal/apps/zoxide.nix
		./terminal/apps/atuin.nix
        ./terminal/apps/bat.nix
        ./terminal/apps/btop.nix
	
		# Neovim
		./terminal/neovim
		
		# Music apps
		
		# Miscellanious apps
		./apps/ghostty.nix
	];

}
