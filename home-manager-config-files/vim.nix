# vim.nix
{ pkgs, ... }:
{
 programs.vim= {
	enable = true;		
	extraConfig = ''
		set number
		set relativenumber		

	'';

};
}

