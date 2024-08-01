{
  xdg = {
    enable = true;
    desktopEntries = {
      evolution = {
        name = "Evolution";
        genericName = "Application";
        exec = "evolution";
        terminal = false;
        categories = [ "Email" "Application" "Network" ];
        mimeType = [ "text/html" "text/xml" ];
        comment = "It is a email client bro";
      };
      swayimg = {
        name = "swayimg";
        genericName = "Image Viewer";
        exec = "swayimg %f";
        terminal = false;
        categories = [ "Graphics" "Viewer" ];
        mimeType = [ "image/jpeg" "image/png" "image/gif" "image/bmp" "image/webp" "image/tiff" ];
        comment = "It opens images bro";
      };
    };
    mime = { enable = true; };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = [ "swayimg.desktop" ];
        "image/png" = [ "swayimg.desktop" ];
        "image/gif" = [ "swayimg.desktop" ];
        "image/bmp" = [ "swayimg.desktop" ];
        "image/webp" = [ "swayimg.desktop" ];
        "image/tiff" = [ "swayimg.desktop" ];
        "application/pdf" = [ "microsoft-edge-stable.desktop" ];
        "x-scheme-handler/msteams"=["teams-for-linux.desktop"];

      };
    };
  };
}

