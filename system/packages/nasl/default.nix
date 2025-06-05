{ pkgs ? import <nixpkgs> { } }:

pkgs.bundlerApp {
  pname = "nasl";
  gemdir = ./.;
  exes = [ "nasl-parse" ];
}
