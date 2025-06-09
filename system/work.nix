# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{

  # Setting up home manager and its options.
  home-manager = {
    users.brams = import ../home/work.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  nixpkgs = {
    config = {
      # https://github.com/NixOS/nixpkgs/issues/171978
      packageOverrides = pkgs: {
        firefox = pkgs.firefox.override {
          extraPolicies = {
            SecurityDevices.p11-kit-proxy =
              "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
          };
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      dpkg
      opensc
      nss.tools
      nss_latest
      pcsc-tools
      pcsclite
      p11-kit
      autoPatchelfHook
      firefox
      cinny-desktop
    ];
    etc."pkcs11/modules/OpenSC".text = ''
      module: ${pkgs.opensc}/lib/onepin-opensc-pkcs11.so
      critical: yes
      log-calls: yes
    '';
  };

  system.configurationRevision = if inputs.self ? rev then
    inputs.self.rev
  else
    throw "Refusing to build from a dirty Git tree!";
}
