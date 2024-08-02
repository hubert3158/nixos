{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings.yazi = {
      opener = [
        {
          edit = {
            run = "nvim '$@'";
            block = true;
          };
        }
        {
          open = {
            run = "xdg-open '$@'";
            desc = "open";
          };
        }
      ];

      open = [
        {
          rules = [
            {
              mime = "text/plain"; use = "edit";
            }
            {
              name = "*.txt"; use = "edit";
            }
          ];
          append_rules = [
            {
              name = "*"; use = "edit";
            }
          ];
        }
      ];
    };
  };
}



    # theme ={
    #   filetype = {
    #     rules = [
    #       { fg = "#7AD9E5"; mime = "image/*"; }
    #       { fg = "#F3D398"; mime = "video/*"; }
    #       { fg = "#F3D398"; mime = "audio/*"; }
    #       { fg = "#CD9EFC"; mime = "application/x-bzip"; }
    #     ];
    #   };
    # };
