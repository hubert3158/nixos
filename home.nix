{ pkgs, ... }:
{
  home.stateVersion = "24.05";  # Use the latest stable version number that aligns with your Home Manager version
  home.username="hubert";
  home.homeDirectory="/home/hubert";
  home.packages = with pkgs; [
    # Add your user packages here
    microsoft-edge
    google-chrome
    jetbrains.idea-ultimate
    discord
    pgadmin4
    pavucontrol
    helix

  ];
 nixpkgs.config = {
              allowUnfree = true;
	      permittedInsecurePackages = [
                "python-2.7.18.8"
              ];
            };


programs.neovim = {
enable = true;
plugins = with pkgs.vimPlugins; [
  yankring
  vim-nix
  { plugin = vim-startify;
    config = "let g:startify_change_to_vcs_root = 0";
  }
];};


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
  };


programs.tmux = {
	enable = true;
	clock24 = true;
	plugins = with pkgs.tmuxPlugins; [
		sensible
		yank
		{
		plugin = catppuccin;
			extraConfig = ''
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator " "
set -g @catppuccin_window_middle_separator " █"
set -g @catppuccin_window_number_position "right"

set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_default_text "#W"

set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_current_text "#W"

set -g @catppuccin_status_modules_right "directory user host session"
set -g @catppuccin_status_left_separator  " "
set -g @catppuccin_status_right_separator ""
set -g @catppuccin_status_fill "icon"
set -g @catppuccin_status_connect_separator "no"

set -g @catppuccin_directory_text "#{pane_current_path}"
			'';
		}
	];
	extraConfig = ''
		set -g mouse on
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
  }
}
'';

};


}
