# Claude Code user-level instructions and MCP servers
# Symlinks ~/.claude/CLAUDE.md to the live-editable copy in the repo, so edits
# apply without a rebuild and stay git-tracked across machines. Repo is public:
# nothing machine-specific or sensitive belongs in this file.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.claude-code;
  claudeDir = "${config.home.homeDirectory}/nixos/home-manager-config-files/claude";
in
{
  options.modules.programs.claude-code = {
    enable = lib.mkEnableOption "Claude Code user-level CLAUDE.md";

    instructionsFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/home-manager-config-files/claude/CLAUDE.md";
      description = "Live-editable user-level CLAUDE.md";
    };
  };

  config = lib.mkIf cfg.enable {
    # No `force`: an existing file is kept as CLAUDE.md.backup, not deleted
    # (home-manager.backupFileExtension in flake.nix).
    home.file.".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink cfg.instructionsFile;

    # Status line: settings.json runs statusline-command.sh, which adds the
    # caveman badge and hands off to claude-powerline (hosts/common/default.nix).
    home.file.".claude/statusline-command.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDir}/statusline.sh";
    home.file.".claude/claude-powerline.json".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDir}/claude-powerline.json";

    # Claude Code keeps MCP servers in ~/.claude.json, which also holds session
    # state and can't be a managed file, so register once instead. The server
    # itself comes from uv-tools.nix.
    home.activation.claudeMcpScrapling = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! ${pkgs.jq}/bin/jq -e '.mcpServers.scrapling' "$HOME/.claude.json" >/dev/null 2>&1; then
        ${pkgs.claude-code}/bin/claude mcp add --scope user scrapling -- "$HOME/.local/bin/scrapling-mcp" || \
          echo "warning: failed to register scrapling MCP server" >&2
      fi
    '';
  };
}
