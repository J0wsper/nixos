{ config, inputs, pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		clock24 = true;
		# extraConfig = ''
		# 	set-option -g default-shell /run/current-system/sw/bin/fish
		# '';
	};
}
