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
  },
window_background_gradient = {
  -- Can be "Vertical" or "Horizontal".  Specifies the direction
  -- in which the color gradient varies.  The default is "Horizontal",
  -- with the gradient going from left-to-right.
  -- Linear and Radial gradients are also supported; see the other
  -- examples below
  orientation = 'Vertical',

  -- Specifies the set of colors that are interpolated in the gradient.
  -- Accepts CSS style color specs, from named colors, through rgb
  -- strings and more
  colors = {
    '#0f0c29',
    '#302b63',
    '#24243e',
  },

  -- Instead of specifying `colors`, you can use one of a number of
  -- predefined, preset gradients.
  -- A list of presets is shown in a section below.
  -- preset = "Warm",

  -- Specifies the interpolation style to be used.
  -- "Linear", "Basis" and "CatmullRom" as supported.
  -- The default is "Linear".
  interpolation = 'Linear',

  -- How the colors are blended in the gradient.
  -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
  -- The default is "Rgb".
  blend = 'Rgb',

  -- To avoid vertical color banding for horizontal gradients, the
  -- gradient position is randomly shifted by up to the `noise` value
  -- for each pixel.
  -- Smaller values, or 0, will make bands more prominent.
  -- The default value is 64 which gives decent looking results
  -- on a retina macbook pro display.
  -- noise = 64,

  -- By default, the gradient smoothly transitions between the colors.
  -- You can adjust the sharpness by specifying the segment_size and
  -- segment_smoothness parameters.
  -- segment_size configures how many segments are present.
  -- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
  -- 1.0 is a soft edge.

  -- segment_size = 11,
  -- segment_smoothness = 0.0,
}
}
'';

};


}
