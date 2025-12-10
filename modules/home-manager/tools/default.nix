# Tools modules aggregator
{ ... }:

{
  imports = [
    ./eza.nix
    ./bat.nix
    ./zoxide.nix
    ./fzf.nix
    ./delta.nix
    ./htop.nix
  ];
}
