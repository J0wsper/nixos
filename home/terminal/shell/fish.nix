{config, pkgs, lib, inputs, ... }:

{
	programs.fish = {
		enable = true;
		generateCompletions = true;
		shellInit = ''
			zoxide init fish | source
			starship init fish | source
			set -g mouse on
		'';
		# shellAbbrs = {
		# 	"cd ..." = "cd ../..";
		# 	"cd ...." = "cd ../../..";
		# 	"cd ....." = "cd ../../../..";
		# };
	};
} 
