{ config, pkgs, lib, inputs, ... }:

{
  programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
      zoxide init fish | source
      atuin init fish | source
      set fish_greeting

      set -gx LS_COLORS $(${lib.getExe pkgs.vivid} generate catppuccin-mocha)
      fish_config theme choose "Catppuccin Mocha"
    '';
    shellInit = ''
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
  xdg.configFile = {
    "fish/themes/Catppuccin Mocha.theme".source =
      "${inputs.catppuccin-fish}/themes/Catppuccin Mocha.theme";
  };
}
