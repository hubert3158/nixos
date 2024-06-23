{ pkgs, ... }:
{
  home.stateVersion = "24.05";  # Use the latest stable version number that aligns with your Home Manager version
  home.username="hubert";
  home.homeDirectory="/home/hubert";
  home.packages = with pkgs; [
    # Add your user packages here
    microsoft-edge
    google-chrome
    tmux
    postgresql
    jetbrains.idea-ultimate
    neovim
    discord
    pgadmin4
    wezterm
    oh-my-zsh
    pavucontrol
    zsh
zsh-autosuggestions
oh-my-zsh
home-manager
  ];
 nixpkgs.config = {
              allowUnfree = true;
            };

  programs.zsh = {
    enable = true;
    autosuggestion = {
    enable = true;
    highlight="fg=red,bold,underline";
    };
    enableCompletion =true;




    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
      ];
    };
  };
}
