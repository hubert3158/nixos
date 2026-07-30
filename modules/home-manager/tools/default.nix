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
    ./uv-tools.nix
    ./fastfetch.nix
    ./cava.nix
    ./patro.nix
    ./ukhaan.nix
  ];
}
