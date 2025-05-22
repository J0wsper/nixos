{config, pkgs, lib, inputs, ... }:

{
	programs.fish = {
		enable = true;
		generateCompletions = true;
		interactiveShellInit = ''
			set fish_greeting
			theme_gruvbox dark medium
		'';
		shellInit = ''
			zoxide init fish | source
			starship init fish | source
		'';
		plugins = [
			{ 
				name = "gruvbox";
				src = pkgs.fishPlugins.gruvbox.src;
			}
			{
				name = "done";
				src = pkgs.fishPlugins.done.src;
			}
			{
				name = "spark";
				src = pkgs.fishPlugins.done.src;
			}
		];
		# shellAbbrs = {};
	};
} 
