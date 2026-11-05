# Worktrunk (`wt`) — git worktree manager for parallel AI agent workflows
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.worktrunk;
in
{
  options.modules.tools.worktrunk = {
    enable = lib.mkEnableOption "Worktrunk git worktree manager";
  };

  config = lib.mkIf cfg.enable {
    # claudeCodeIntegration left off: it writes through programs.claude-code,
    # but ~/.claude/settings.json is hand-managed here, not by home-manager.
    programs.worktrunk = {
      enable = true;
      package = pkgs.worktrunk;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
