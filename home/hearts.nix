{ pkgs, inputs, ... }:

{
  home.username = "brams";
  home.stateVersion = "24.11";
  fonts.fontconfig.enable = true;

  nix.registry.n.flake = inputs.nixpkgs;

  home.packages = with pkgs; [
    discord
    strawberry
    texlive.combined.scheme-medium
    zathura
  ];

  imports = [ ];

}
