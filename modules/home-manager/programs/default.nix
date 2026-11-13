# Programs modules aggregator
{ ... }:

{
  imports = [
    ./git.nix
    ./lazygit.nix
    ./ssh.nix
    ./gpg.nix
    ./tmux.nix
    ./browsers.nix
    ./media.nix
    ./nix-index.nix
    ./emacs.nix
    ./helix.nix
    ./herdr.nix
    ./claude-code.nix
  ];
}
