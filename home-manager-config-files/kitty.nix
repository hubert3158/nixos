{pkgs, ...}:{
  programs.kitty ={
    enable = true;
    font = {
      name = "FiraCode Nerd Font" ;
      size = 14;
      package = pkgs.nerdfonts;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
    keybindings =  {
        "ctrl+c" = "copy_or_interrupt";
    };
    shellIntegration = {
      mode = "default"; 
      enableZshIntegration =true;
    };
  };
}
