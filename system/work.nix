# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{

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
      permittedInsecurePackages = [ "jujutsu-0.23.0" ];
    };
  };

  # Setting up home manager and its options.
  home-manager = {
    users.brams = import ../home/work.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  programs.firefox.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enabling fish system-wide is necessary to make it the default shell.
  programs.fish.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # NOTE: This is important if you need to enable an NVIDIA GPU
  # https://discourse.nixos.org/t/pytorch-with-cuda-support/51189/8
  environment.systemPackages = with pkgs; [
    vim
    wget
    bat
    git
    btop
    hyperfine
    python3
    ripgrep
    neovim
    fd
    eza
    fzf
    openssh
  ];

  # Getting nerd fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ nerd-fonts.fira-code nerd-fonts.droid-sans-mono ];
  };

  system.configurationRevision = if inputs.self ? rev then
    inputs.self.rev
  else
    throw "Refusing to build from a dirty Git tree!";
}
