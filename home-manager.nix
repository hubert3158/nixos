
{ pkgs, ... }:
{
  home.stateVersion = "24.05";  # Use the latest stable version number that aligns with your Home Manager version
  home.username="hubert";
  home.homeDirectory="/home/hubert";
  home.shellAliases = {
	  "gs" = "git status";
	  "gaa" = "git add .";
	  "gp" = "git push";
	  "gwip" = "git commit -m \"wip\"";
	  "v" = "nvim";
	  "vi" = "nvim";
	  "f" = ''
		  fzf \
		  -i \
		  --margin 5% --padding 5% --border --preview 'cat {}' \
		  --bind 'enter:execute(nvim {})' \
		  --color bg:#222222,preview-bg:#333333
		  '';
  };


  home.packages = with pkgs; [
    # Add your user packages here
    microsoft-edge
    google-chrome
    jetbrains.idea-ultimate
jetbrains.pycharm-professional

    discord
    pgadmin4
    pavucontrol
    helix
    zsh-autocomplete
    mtr
flameshot
postman
teams-for-linux
ripgrep
lazygit


nmap
nikto
zap

wireshark-qt



obsidian
pandoc
texlive.combined.scheme-full
mdbook-pdf


protonvpn-cli_2

    (python312.withPackages (ps: with ps; [ reportlab ])) 


  ];
 nixpkgs.config = {
              allowUnfree = true;
	      permittedInsecurePackages = [
                "python-2.7.18.8"
              ];
            };

  imports = [
    ./home-manager-config-files/tmux.nix
    ./home-manager-config-files/vim.nix
    ./home-manager-config-files/neovim.nix
  ];

  programs.zsh = {
    enable = true;
    autosuggestion = {
    enable = true;
    highlight="fg=red,bold,underline";
    };
    enableCompletion =true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
      ];
    };
profileExtra= ''
export NIXOS_PROFILE=work
'';
  };




programs.wezterm = {
enable = true;
  #color_scheme = "Catppuccin Frappé (Gogh)",
extraConfig = ''
return {
  font = wezterm.font("JetBrains Mono"),
  font_size = 16.0,
  color_scheme = "Catppuccin Frappe",
  hide_tab_bar_if_only_one_tab = true,
  default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
  keys = {
    {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
  },
window_background_image = '/home/hubert/nixos/images/wallpaper.png'
}
'';

};

  programs.ssh= {
    enable = true;
    extraConfig = ''
Host *
    ForwardAgent yes
    ForwardX11 no
    ForwardX11Trusted yes
    ServerAliveInterval 60
    ServerAliveCountMax 30

Host stg
    HostName staging.v2.smartmca.com
    User ubuntu
    Port 22
    IdentityFile ~/.ssh/staging.v2.pem

Host prod
    HostName app.v2.smartmca.com
    User ubuntu
    Port 22
    IdentityFile ~/.ssh/prod.v2.pem
'';
};

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Subash Acharya";
      user.email = "subash@example.com";
      core.editor = "vim";
      alias.co = "checkout";
      alias.br = "branch";
      alias.ci = "commit";
      alias.st = "status";
      alias.lg = "log --graph --oneline --all";
      commit.gpgSign = false;

    };
  };


}


