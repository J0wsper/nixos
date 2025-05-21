{
	description = "Bram's NixOS config!";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
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
