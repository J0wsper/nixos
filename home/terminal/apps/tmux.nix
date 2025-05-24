{ config, inputs, pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		clock24 = true;
		plugins = with pkgs; [
			tmuxPlugins.better-mouse-mode
			tmuxPlugins.vim-tmux-navigator
			tmuxPlugins.yank
			tmuxPlugins.gruvbox	
		];
		extraConfig = ''
			set -g mouse on
			# https://vi.stackexchange.com/questions/16148/slow-vim-escape-from-insert-mode
			set -sg escape-time 10 

			bind -n M-h select-pane -L
			bind -n M-j select-pane -D
			bind -n M-k select-pane -U
			bind -n M-l select-pane -R
		'';
		
	};
}
