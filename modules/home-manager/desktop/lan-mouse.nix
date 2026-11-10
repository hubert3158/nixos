# Lan Mouse — share this keyboard + mouse with the Windows machine over the LAN.
# Picked over Deskflow/Input Leap: it captures through layer-shell and emulates
# through wlroots virtual-pointer directly, so it doesn't depend on Hyprland's
# portal (no InputCapture/RemoteDesktop bugs). No clipboard sync yet upstream.
#
# The daemon runs as a user service; the `lan-mouse` GUI (or `lan-mouse cli`)
# attaches to it to add peers and accept fingerprints. Peers + accepted keys
# live in ~/.config/lan-mouse/ (machine-specific, not tracked). UDP 4242 is
# opened in modules/nixos/networking.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.lan-mouse;
in
{
  options.modules.desktop.lan-mouse.enable =
    lib.mkEnableOption "Lan Mouse keyboard/mouse sharing daemon";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lan-mouse ];

    systemd.user.services.lan-mouse = {
      Unit = {
        Description = "Lan Mouse keyboard/mouse sharing daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse daemon";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
