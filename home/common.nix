{ config, pkgs, lib, inputs, ... }:

{
	home.username = "brams";
	home.stateVersion = "24.11";
	# fonts.fontconfig.enable = true;

	home.packages = [
		pkgs.manix
	];

	imports = [
		# Shell apps
		./terminal/shell/fish.nix

		# Terminal apps
		./terminal/apps/jujutsu.nix
		./terminal/apps/starship.nix
		./terminal/apps/tmux.nix
		./terminal/apps/zoxide.nix
		
		# Music apps
		
		# Miscellanious apps
	];

}
