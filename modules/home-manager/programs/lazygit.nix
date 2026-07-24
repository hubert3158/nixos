# Lazygit — Kanagawa Ink & Wave theme (docs/THEME.md)
# Used daily via nvim <leader>gg (lazygit.nvim) and the CLI.
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.programs.lazygit;
in
{
  options.modules.programs.lazygit = {
    enable = lib.mkEnableOption "Lazygit terminal git UI";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          showFileTree = true;
          border = "rounded";
          theme = {
            activeBorderColor = [ palette.crystalBlue "bold" ];
            inactiveBorderColor = [ palette.sumiInk6 ];
            searchingActiveBorderColor = [ palette.carpYellow "bold" ];
            optionsTextColor = [ palette.springBlue ];
            selectedLineBgColor = [ palette.waveBlue1 ];
            cherryPickedCommitBgColor = [ palette.waveBlue2 ];
            cherryPickedCommitFgColor = [ palette.carpYellow ];
            unstagedChangesColor = [ palette.waveRed ];
            defaultFgColor = [ palette.fujiWhite ];
          };
        };
        # new-schema pagers array (git.paging was removed; the old key trips
        # an auto-migration that can't write back to the read-only HM symlink)
        git.pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };
    };
  };
}
