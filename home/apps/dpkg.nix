{ config, lib, pkgs, ... }:

# I need this for work
{
  programs.dpkg = { enable = true; };
}
