{ config, pkgs, lib, inputs, ... }:

{
	home.username = "brams";
	home.stateVersion = "24.11";
	fonts.fontconfig.enable = true;

	home.packages = [
		pkgs.manix
	];

	# nix.registry.n.flake = inputs.nixpkgs;
	
	imports = [
		./terminal/fish.nix
		./terminal/jujutsu.nix
		./terminal/starship.nix
	];

}
