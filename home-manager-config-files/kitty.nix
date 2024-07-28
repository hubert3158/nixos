{pkgs, ...}:{
  programs.kitty ={
    enable = true;
    font = {
      name = "FiraCode Nerd Font" ;
      size = 14;
      package = pkgs.nerdfonts;
    };
  };
}
