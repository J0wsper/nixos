{ config, pkgs, inputs, ... }:

{
  home.username = "brams";
  home.stateVersion = "24.11";
  fonts.fontconfig.enable = true;

  nix.registry.n.flake = inputs.nixpkgs;

  home.packages = with pkgs; [ manix xsel ];

  imports = [
    # Shell apps
    ./terminal/shell/fish.nix

    # Terminal apps
    ./terminal/apps/jujutsu.nix
    ./terminal/apps/tmux.nix
    ./terminal/apps/zoxide.nix
    ./terminal/apps/atuin.nix
    ./terminal/apps/bat.nix
    ./terminal/apps/btop.nix

    # Neovim
    ./terminal/neovim

    # Miscellanious apps
    ./apps/ghostty.nix
  ];

}
