{
	description = "Bram's NixOS config!";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			# sha256 = "1mwq9mzyw1al03z4q2ifbp6d0f0sx9f128xxazwrm62z0rcgv4na";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
		nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ ./system/configuration.nix ];
			specialArgs = { inherit inputs; };
		};
	};
}
