# XDG configuration (desktop entries, MIME types)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.xdg;
in
{
  options.modules.desktop.xdg = {
    enable = lib.mkEnableOption "XDG configuration";
  };

  config = lib.mkIf cfg.enable {
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

        nvim = {
          name = "neovim";
          genericName = "file editor";
          exec = "nvim %f";
          terminal = true;
          categories = [ "TextEditor" "Utility" ];
          mimeType = [ "text/plain" ];
          comment = "Its a beast bro";
        };

        workspacesclient = {
          name = "AWS Workspaces Client";
          genericName = "AWS Workspaces Client";
          exec = "workspacesclient";
          terminal = false;
          categories = [ "Network" "Utility" ];
          mimeType = [ "text/plain" ];
          comment = "needed at work bro";
        };

        chromeDebugMode = {
          name = "Chrome Debug Mode";
          genericName = "Chrome Debug Mode";
          exec = "google-chrome-stable --remote-debugging-port=9222 --no-first-run --new-instance";
          terminal = false;
          categories = [ "Network" ];
          mimeType = [ "text/plain" ];
          comment = "needed at work bro";
        };

        clipHist = {
          name = "ClipHist";
          genericName = "Clipboard History";
          exec = ''
            ${pkgs.bash}/bin/bash -lc "cliphist list | sort -nr -k1,1 | fuzzel --dmenu | cut -f1 | xargs -r -n1 cliphist decode | wl-copy"
          '';
          terminal = false;
          categories = [ "Utility" ];
          mimeType = [ "text/plain" ];
          comment = "Clipboard manager";
        };
      };

      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/jpeg" = [ "swayimg.desktop" ];
          "image/png" = [ "swayimg.desktop" ];
          "image/gif" = [ "swayimg.desktop" ];
          "image/bmp" = [ "swayimg.desktop" ];
          "image/webp" = [ "swayimg.desktop" ];
          "image/tiff" = [ "swayimg.desktop" ];
          "application/pdf" = [ "microsoft-edge.desktop" ];
          "x-scheme-handler/msteams" = [ "teams-for-linux.desktop" ];
          "text/plain" = [ "nvim.desktop" ];
          "text/markdown" = [ "google-chrome-stable.desktop" ];
          "text/csv" = [ "libreoffice-calc.desktop" ];
        };
      };
    };
  };
}
