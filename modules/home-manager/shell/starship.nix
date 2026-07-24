# Starship prompt — Kanagawa powerline ribbon (Ink & Wave design system)
# Segments flow ink-dark → light: os ▸ directory ▸ git ▸ langs ▸ duration
# Colours from lib/palette.nix, re-exported as a starship palette so the
# format strings can stay readable (bg:crystal_blue rather than bg:#7E9CD8).
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.shell.starship;
in
{
  options.modules.shell.starship = {
    enable = lib.mkEnableOption "Starship prompt";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        scan_timeout = 1000;
        command_timeout = 2000;
        add_newline = true;
        palette = "kanagawa";

        format = lib.concatStrings [
          "[](crystal_blue)"
          "$os"
          "[](bg:wave_blue2 fg:crystal_blue)"
          "$directory"
          "[](fg:wave_blue2 bg:sumi_ink4)"
          "$git_branch"
          "$git_status"
          "[](fg:sumi_ink4 bg:sumi_ink5)"
          "$nodejs"
          "$rust"
          "$golang"
          "$python"
          "$java"
          "$nix_shell"
          "[](fg:sumi_ink5 bg:sumi_ink0)"
          "$cmd_duration"
          "$jobs"
          "[ ](fg:sumi_ink0)"
          "$line_break"
          "$character"
        ];

        # quiet clock on the right edge
        right_format = "$time";
        time = {
          disabled = false;
          time_format = "%H:%M";
          style = "fg:fuji_gray";
          format = "[󰥔 $time]($style)";
        };

        palettes.kanagawa = {
          sumi_ink0 = palette.sumiInk0;
          sumi_ink4 = palette.sumiInk4;
          sumi_ink5 = palette.sumiInk5;
          wave_blue2 = palette.waveBlue2;
          crystal_blue = palette.crystalBlue;
          spring_blue = palette.springBlue;
          oni_violet = palette.oniViolet;
          carp_yellow = palette.carpYellow;
          spring_green = palette.springGreen;
          wave_red = palette.waveRed;
          peach_red = palette.peachRed;
          fuji_white = palette.fujiWhite;
          old_white = palette.oldWhite;
          fuji_gray = palette.fujiGray;
        };

        os = {
          disabled = false;
          style = "bg:crystal_blue fg:sumi_ink0";
          symbols = {
            NixOS = "󱄅 ";
            Linux = "󰌽 ";
            Macos = "󰀵 ";
          };
        };

        directory = {
          style = "bg:wave_blue2 fg:fuji_white";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = "󰉍 ";
            "Music" = "󰝚 ";
            "Pictures" = "󰉏 ";
            "nixos" = "󱄅 nixos";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:sumi_ink4 fg:carp_yellow";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:sumi_ink4 fg:carp_yellow";
          format = "[$all_status$ahead_behind ]($style)";
          conflicted = "󰞇 ";
          ahead = "⇡\${count} ";
          behind = "⇣\${count} ";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";
          untracked = "?\${count} ";
          stashed = "󰏗 ";
          modified = "!\${count} ";
          staged = "+\${count} ";
          deleted = "✘\${count} ";
        };

        nodejs = {
          symbol = "󰎙";
          style = "bg:sumi_ink5 fg:spring_green";
          format = "[ $symbol ($version) ]($style)";
        };
        rust = {
          symbol = "󱘗";
          style = "bg:sumi_ink5 fg:wave_red";
          format = "[ $symbol ($version) ]($style)";
        };
        golang = {
          symbol = "󰟓";
          style = "bg:sumi_ink5 fg:spring_blue";
          format = "[ $symbol ($version) ]($style)";
        };
        python = {
          symbol = "󰌠";
          style = "bg:sumi_ink5 fg:carp_yellow";
          format = "[ $symbol ($version) ]($style)";
        };
        java = {
          symbol = "󰬷";
          style = "bg:sumi_ink5 fg:peach_red";
          format = "[ $symbol ($version) ]($style)";
        };
        nix_shell = {
          symbol = "󱄅";
          style = "bg:sumi_ink5 fg:crystal_blue";
          format = "[ $symbol $state ]($style)";
        };

        cmd_duration = {
          min_time = 500;
          style = "bg:sumi_ink0 fg:old_white";
          format = "[ 󱎫 $duration ]($style)";
        };

        jobs = {
          symbol = "󰒲";
          style = "bg:sumi_ink0 fg:oni_violet";
          format = "[ $symbol $number ]($style)";
        };

        character = {
          success_symbol = "[❯](bold fg:crystal_blue)";
          error_symbol = "[❯](bold fg:peach_red)";
          vimcmd_symbol = "[❮](bold fg:spring_green)";
        };
      };
    };
  };
}
