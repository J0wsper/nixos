# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  # Setting up home manager and its options.
  home-manager = {
    users.brams = import ../home/hearts.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  nix.settings.trusted-users = [ "@admin" ];

  # Enabling the Nix garbage collector
  nix.gc = {
    automatic = true;
    options = "--delete-old";
  };

  programs.firefox.enable = true;

  # Steam cannot be configured in Home Manger easily, so the best solution I found is to enable it
  # system-wide like so.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  system.configurationRevision = if inputs.self ? rev then
    inputs.self.rev
  else
    throw "Refusing to build from a dirty Git tree!";
}
