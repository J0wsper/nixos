{config, pkgs, lib, inputs, ... }:

{
	programs.fish = {
		enable = true;
		generateCompletions = true;
	};
} 
