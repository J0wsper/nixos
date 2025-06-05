{
  description = "Bram's NixOS config!";
  inputs = {
    # Flake inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-flake inputs
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-fish = {
      url = "github:catppuccin/fish";
      flake = false;
    };
    falcon-sensor = {
      url = "path:system/packages/falcon.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      flake = false;
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations."work" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./system/nixos-common.nix ./system/common.nix ];
      specialArgs = { inherit inputs; };
    };
  };
}
