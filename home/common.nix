{ config, pkgs, lib, inputs, ... }:

{
	home.username = "brams";
	home.stateVersion = "24.11";
	fonts.fontconfig.enable = true;

	home.packages = [
		pkgs.manix
	];

	imports = [
		# Terminal apps
		./terminal/apps/fish.nix
		./terminal/apps/jujutsu.nix
		./terminal/apps/starship.nix
		./terminal/apps/tmux.nix
		
		# Music apps
		
		# Miscellanious apps
	];

}
