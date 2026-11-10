# KDE Connect — send files and sync the clipboard with the Windows machine
# (Lan Mouse shares keyboard/mouse but has no clipboard). Runs the daemon and
# the tray indicator (waybar tray) as user services on graphical-session.
# Clipboard on Hyprland goes through wlr-data-control, no KDE session needed.
# The package and firewall range (TCP+UDP 1714-1764) come from
# programs.kdeconnect in hosts/common/default.nix. Pairing is per machine:
# accept the request in the tray / `kdeconnect-app`; keys live in
# ~/.config/kdeconnect/ (not tracked).
{ config, lib, ... }:

let
  cfg = config.modules.desktop.kdeconnect;
in
{
  options.modules.desktop.kdeconnect.enable =
    lib.mkEnableOption "KDE Connect daemon and tray indicator";

  config = lib.mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
