{ config, inputs, pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		clock24 = true;
		plugins = with pkgs; [
			tmuxPlugins.better-mouse-mode
			tmuxPlugins.vim-tmux-navigator
			tmuxPlugins.gruvbox	
		];

		# https://www.reddit.com/r/NixOS/comments/12mdyzv/need_help_installing_tmux_plugins_through/
		extraConfig = ''
			set -g mouse on

			bind -n M-h select-pane -L
			bind -n M-j select-pane -D
			bind -n M-k select-pane -U
			bind -n M-l select-pane -R
		'';
		
	};
}
