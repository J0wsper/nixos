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

           # https://github.com/edouard-lopez/tmux-tomorrow 
           set -g default-terminal "screen-256color"
           set-option -sg escape-time 10

           set -g @catppuccin_flavor 'mocha'

           bind -n M-h select-pane -L
           bind -n M-j select-pane -D
           bind -n M-k select-pane -U
           bind -n M-l select-pane -R
      	'';
  };
}
