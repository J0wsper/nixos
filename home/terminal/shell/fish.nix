{config, pkgs, lib, inputs, ... }:

{
	programs.fish = {
		enable = true;
		generateCompletions = true;
		interactiveShellInit = ''
			zoxide init fish | source
			atuin init fish | source
			set fish_greeting
		'';
		shellInit = ''
            		fish_config theme choose "Tomorrow Night"
			if test -z "$TMUX"
				tmux
			end
		'';
		plugins = [
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
