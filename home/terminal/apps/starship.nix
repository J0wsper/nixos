{config, pkgs, lib, inputs, ... }:

{
	programs.starship = {
		enable = true;
		settings = {
			add_newline = true;
			scan_timeout = 50;
		};
	};
} 
