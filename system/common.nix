# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./nixos-common.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brams = {
    isNormalUser = true;
    description = "Bram Schuijff";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  nixpkgs = {
    config = {
        allowUnfree = true;
    	permittedInsecurePackages = [
      		"jujutsu-0.23.0"
      	];
     };
  };
  
  # Setting up home manager and its options.
  home-manager = {
        users.brams = import ../home/common.nix;
        useGlobalPkgs = true;
        useUserPackages = true;
  };

  programs.firefox.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  # Enabling fish system-wide is necessary to make it the default shell.
  programs.fish.enable = true;

  # Steam cannot be configured in Home Manger easily, so the best solution I found is to enable it
  # system-wide like so.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	vim
  	wget
  ];
  
  # Getting nerd fonts
  fonts = {
    enableDefaultPackages = true;
    # packages = with pkgs; [
    #   nerd-fonts.fira-code
    #   nerd-fonts.droid-sans-mono
    # ];
  };

  system.configurationRevision =
    if inputs.self ? rev then
      inputs.self.rev
    else
      throw "Refusing to build from a dirty Git tree!";

}
