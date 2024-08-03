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
