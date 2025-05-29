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
        tomorrow-bat = {
            url = "github:J0wsper/tomorrow-night";
            flake = false;
        };
	};
	outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
		nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ 
				./system/nixos-common.nix
				./system/common.nix
			 ];
			specialArgs = { inherit inputs; };
		};
	};
}
