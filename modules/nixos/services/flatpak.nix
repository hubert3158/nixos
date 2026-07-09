# Flatpak configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.flatpak;
in
{
  options.modules.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak support";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    # Expose fonts to Flatpak with resolved symlinks so sandboxed apps
    # can access them without needing /nix/store access
    system.fsPackages = [ pkgs.bindfs ];
    fileSystems."/usr/share/fonts" = {
      device = let
        aggregatedFonts = pkgs.buildEnv {
          name = "system-fonts";
          paths = config.fonts.packages;
          pathsToLink = [ "/share/fonts" ];
          ignoreCollisions = true;
        };
      in "${aggregatedFonts}/share/fonts";
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };

    # Microsoft Edge policies (disables sidebar/Copilot that cause flickering on tiling WMs)
    environment.etc."opt/edge/policies/managed/edge-policy.json".text = builtins.toJSON {
      HubsSidebarEnabled = false;
      StandaloneHubsSidebarEnabled = false;
      Microsoft365CopilotChatIconEnabled = false;
      NewTabPageBingChatEnabled = false;
    };
  };
}
