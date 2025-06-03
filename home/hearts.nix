{ config, pkgs, lib, inputs, ... }:

{
  home.username = "brams";
  home.stateVersion = "24.11";
  fonts.fontconfig.enable = true;

  nix.registry.n.flake = inputs.nixpkgs;

  home.packages = [ pkgs.discord pkgs.strawberry ];

  imports = [ ];

}
