# Programs modules aggregator
{ ... }:

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./tmux.nix
    ./neovim.nix
    ./browsers.nix
    ./media.nix
    ./nix-index.nix
  ];
}
