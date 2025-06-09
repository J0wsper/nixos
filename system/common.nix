# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ ./nixos-common.nix ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brams = {
    name = "brams";
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
    users.brams = import ../home/common.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    keep-derivations = true;
    keep-outputs = true;
  };

  # Enabling fish system-wide is necessary to make it the default shell.
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  # List packages installed in system profile. To search, run:
  environment = {
    systemPackages = with pkgs; [
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
      zlib
      llvmPackages_16.libstdcxxClang
      clang
      clang-tools
    ];
  };

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
