# neovim.nix
{ pkgs, ... }:
{
 programs.neovim= {
	enable = true;
	extraLuaPackages = luaPkgs: with luaPkgs; [ luautf8 ];
	extraLuaConfig = ''
			'';
};
}

