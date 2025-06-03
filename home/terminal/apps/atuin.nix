{ config, pkgs, lib, inputs, ... }:

{
  programs.atuin = {
    enable = true;
    settings = {
      style = "auto";
      enter_accept = true;
      keymap_mode = "vim-insert";
      scroll_exits = false;
    };
  };
}
