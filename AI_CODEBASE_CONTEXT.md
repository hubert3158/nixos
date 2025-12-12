# NixOS Configuration Codebase - AI Context Document

> **Purpose:** This document provides comprehensive context about this NixOS configuration codebase for AI assistants. It enables faster understanding and more accurate assistance without requiring extensive codebase exploration.

> **Last Updated:** 2025-12-12
> **Git Branch:** dev (main branch: master)
> **Recent Major Change:** Modular architecture rework (commit 7f25ad6)

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Directory Structure](#directory-structure)
3. [Architecture & Design Patterns](#architecture--design-patterns)
4. [Module System](#module-system)
5. [Neovim Configuration](#neovim-configuration)
6. [Key Configuration Files](#key-configuration-files)
7. [Development Environment](#development-environment)
8. [Build & Deployment](#build--deployment)
9. [Common Tasks](#common-tasks)
10. [Technical Specifications](#technical-specifications)

---

## Project Overview

### What This Is

A **production-grade, modular NixOS configuration** managing multiple Linux systems (work and home) using Nix Flakes. This is a sophisticated personal/professional development environment emphasizing:

- **Reproducibility:** Bit-for-bit reproducible builds via flakes
- **Modularity:** 77+ independent, toggleable modules
- **Professional Development:** Full-stack, systems programming, JVM development support
- **Advanced Neovim:** 80+ plugins, custom build, LSP for 10+ languages
- **Multi-Host Support:** Shared common base with host-specific overrides

### Primary Use Cases

1. Software development (Node.js, Python, Go, Rust, Java, C/C++, Zig)
2. System administration (Docker, PostgreSQL, SSH)
3. Daily computing (Hyprland/i3 desktop, productivity tools)
4. Configuration management (declarative, version-controlled)

---

## Directory Structure

```
/home/hubert/nixos/
├── flake.nix                    # Entry point - defines all configurations
├── flake.lock                   # Locked dependency versions (61 entries)
├── README.md                    # Project documentation
│
├── lib/                         # Helper functions
│   └── default.nix             # mkHost, forAllSystems, pkgsFor
│
├── modules/                     # Core modular architecture
│   ├── nixos/                  # System-level modules (45 files)
│   │   ├── boot.nix            # Bootloader (systemd-boot/GRUB)
│   │   ├── networking.nix      # Network, DNS, firewall
│   │   ├── nix-settings.nix    # Nix daemon, flakes, GC
│   │   ├── users.nix           # User accounts
│   │   ├── locale.nix          # Timezone, i18n
│   │   ├── security.nix        # Sudo, polkit
│   │   ├── secrets.nix         # SOPS integration
│   │   ├── desktop/            # Desktop environments
│   │   │   ├── hyprland.nix    # Wayland compositor (primary)
│   │   │   ├── i3.nix          # X11 fallback
│   │   │   └── sddm.nix        # Display manager
│   │   ├── hardware/           # Hardware support
│   │   │   ├── audio.nix       # Pipewire
│   │   │   ├── bluetooth.nix   # Bluez
│   │   │   └── graphics.nix    # GPU, VDPAU
│   │   ├── services/           # System services
│   │   │   ├── docker.nix      # Container runtime
│   │   │   ├── postgresql.nix  # Database
│   │   │   ├── openssh.nix     # SSH server
│   │   │   ├── flatpak.nix     # App sandboxing
│   │   │   └── printing.nix    # CUPS
│   │   └── development/        # Dev tools
│   │       ├── languages.nix   # Runtimes (Node, Python, etc.)
│   │       └── tools.nix       # LSPs, formatters, debuggers
│   │
│   └── home-manager/           # User-level modules (32 files)
│       ├── shell/              # Shell configurations
│       │   ├── zsh.nix         # Zsh + oh-my-zsh
│       │   ├── fish.nix        # Fish shell
│       │   ├── starship.nix    # Prompt
│       │   └── aliases.nix     # Shell aliases
│       ├── terminals/          # Terminal emulators
│       │   ├── wezterm.nix     # Primary terminal
│       │   ├── kitty.nix       # Alternative
│       │   └── ghostty.nix     # Alternative
│       ├── programs/           # User programs
│       │   ├── git.nix         # Git + delta
│       │   ├── neovim.nix      # Neovim integration
│       │   ├── tmux.nix        # Terminal multiplexer
│       │   ├── ssh.nix         # SSH client
│       │   └── gpg.nix         # GPG encryption
│       ├── desktop/            # Desktop user config
│       │   ├── hyprland.nix    # Hyprland user settings
│       │   ├── hyprlock.nix    # Screen locker
│       │   ├── i3.nix          # i3 user settings
│       │   └── xdg.nix         # XDG directories
│       ├── file-managers/      # File managers
│       │   ├── yazi.nix        # TUI file manager
│       │   └── ranger.nix      # Alternative
│       ├── tools/              # CLI tools
│       │   ├── eza.nix         # Modern ls
│       │   ├── bat.nix         # Modern cat
│       │   ├── fzf.nix         # Fuzzy finder
│       │   ├── htop.nix        # Process monitor
│       │   └── zoxide.nix      # Smart cd
│       └── packages.nix        # User package list
│
├── packages/                   # Custom package definitions
│   └── neovim/                # Custom Neovim build
│       └── default.nix        # 80+ plugins, custom config
│
├── overlays/                   # Nixpkgs overlays
│   └── default.nix            # Custom package overrides
│
├── hosts/                      # Host-specific configurations
│   ├── common/                # Shared by all hosts
│   │   └── default.nix        # Common system config
│   ├── work/                  # Work machine
│   │   ├── default.nix        # Work-specific overrides
│   │   └── hardware-configuration.nix
│   └── home/                  # Home machine
│       ├── default.nix        # Home-specific overrides
│       └── hardware-configuration.nix
│
├── nvim/                       # Neovim configuration (Lua)
│   ├── init.lua               # Main entry point (1003 lines)
│   ├── lua/user/              # User modules (22 files)
│   │   ├── lsp.lua            # LSP configuration
│   │   ├── mason.nix          # LSP installer
│   │   ├── telescope.lua      # Fuzzy finder
│   │   ├── neo-tree.lua       # File explorer
│   │   ├── conform.lua        # Formatter
│   │   ├── nvimLint.lua       # Linter
│   │   ├── codeCompanion.lua  # AI assistant
│   │   ├── harpoon.lua        # File navigation
│   │   ├── git-conflict.lua   # Git merge helper
│   │   ├── nvimUfo.lua        # Folding
│   │   └── [17 more...]
│   ├── plugin/                # Plugin configurations
│   │   ├── cmp.lua            # Completion
│   │   ├── dap.lua            # Debugger
│   │   ├── lsp.lua            # LSP handlers
│   │   ├── treesitter.lua     # Syntax parsing
│   │   ├── telescope.lua      # Telescope setup
│   │   └── [6 more...]
│   ├── ftplugin/              # Filetype plugins
│   │   ├── lua.lua
│   │   └── nix.lua
│   └── after/                 # Post-load configs
│
├── dotfiles/                   # External configurations
│   ├── hypr/                  # Hyprland configs
│   ├── eww/                   # EWW widgets
│   ├── ghostty/               # Ghostty terminal
│   ├── completions/           # Shell completions
│   ├── configFiles/           # Misc configs
│   └── java/                  # Java IDE configs
│
├── scripts/                    # Utility scripts (19 files)
│   ├── build.sh               # Build system
│   ├── update.sh              # Update dependencies
│   ├── n8n.sh, prod.sh, stg.sh # Deployment scripts
│   └── [14 more...]
│
├── secrets/                    # Encrypted secrets
│   └── secrets.yaml           # SOPS-encrypted
│
└── images/                     # Wallpapers and assets
```

---

## Architecture & Design Patterns

### 1. Modular Options Pattern

Every module follows this structure:

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.<category>.<name>;
in
{
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "description";
    # Custom options with types and defaults
    setting = lib.mkOption {
      type = lib.types.str;
      default = "value";
      description = "What this does";
    };
  };

  config = lib.mkIf cfg.enable {
    # Implementation only runs if enabled
    # All configuration goes here
  };
}
```

**Benefits:**
- Self-documenting via `options`
- Type-safe with compile-time validation
- Independently toggleable
- Discoverable via `nixos-help`

### 2. Host Specialization with Common Base

```
hosts/common/default.nix (shared configuration - 90%)
  ↓
hosts/work/default.nix (imports common + work-specific overrides)
hosts/home/default.nix (imports common + home-specific overrides)
```

**Pattern:**
```nix
# hosts/work/default.nix
{ ... }: {
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  # Only override what's different
  networking.hostName = "work-laptop";
  modules.development.java.enable = true;  # Work needs Java
}
```

### 3. Recursive Module Aggregation

```nix
# modules/nixos/default.nix
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./desktop
    ./services
    ./development
    # ... all modules
  ];
}
```

This allows `flake.nix` to import entire module trees with one line:
```nix
imports = [ ./modules/nixos ];
```

### 4. Overlay-Based Custom Packages

```nix
# overlays/default.nix
final: prev: {
  nvim-pkg = prev.callPackage ../packages/neovim { };
}
```

Allows custom Neovim build to be available as `pkgs.nvim-pkg` throughout the system.

### 5. User vs System Separation

| Aspect | NixOS Modules | Home Manager Modules |
|--------|---------------|---------------------|
| **Scope** | System-wide | Per-user |
| **Requires** | Root/sudo | User permissions |
| **Examples** | Boot, networking, services | Shell, dotfiles, user packages |
| **Config Location** | `/etc/nixos` | `~/.config/home-manager` |

### 6. Secrets Management (SOPS)

```nix
# modules/nixos/secrets.nix
sops = {
  defaultSopsFile = ../../secrets/secrets.yaml;
  age.keyFile = "/home/hubert/.config/sops/age/keys.txt";
  secrets.example = {
    owner = "hubert";
  };
};
```

Secrets are encrypted at rest, decrypted at boot, never stored in Nix store.

---

## Module System

### Module Categories

#### NixOS Modules (`modules.nixos.*`)

**Core System:**
- `boot` - Bootloader (systemd-boot/GRUB), kernel params
- `networking` - Hostname, NetworkManager, DNS, firewall
- `nix-settings` - Nix daemon, flakes, auto GC, optimization
- `users` - User accounts, groups, shells
- `locale` - Timezone, keyboard, i18n
- `security` - Sudo, polkit, PAM
- `secrets` - SOPS integration

**Desktop:**
- `desktop.hyprland` - Wayland compositor
- `desktop.i3` - X11 window manager
- `desktop.sddm` - Display manager

**Hardware:**
- `hardware.audio` - Pipewire, ALSA, PulseAudio
- `hardware.bluetooth` - Bluez, device support
- `hardware.graphics` - OpenGL, Vulkan, VDPAU

**Services:**
- `services.docker` - Container runtime
- `services.postgresql` - Database server
- `services.openssh` - SSH daemon
- `services.flatpak` - App sandboxing
- `services.printing` - CUPS printer support

**Development:**
- `development.languages` - Node, Python, Go, Rust, Java, C/C++, Zig
- `development.tools` - LSP servers, formatters, debuggers, Terraform

#### Home Manager Modules (`modules.home-manager.*`)

**Shell:**
- `shell.zsh` - Zsh + oh-my-zsh, vi-mode
- `shell.fish` - Fish shell
- `shell.starship` - Cross-shell prompt
- `shell.aliases` - Common shell aliases

**Terminals:**
- `terminals.wezterm` - GPU-accelerated terminal
- `terminals.kitty` - Alternative terminal
- `terminals.ghostty` - Another alternative

**Programs:**
- `programs.git` - Git with delta diffs
- `programs.neovim` - Neovim integration
- `programs.tmux` - Terminal multiplexer
- `programs.ssh` - SSH client config
- `programs.gpg` - GPG encryption

**Desktop:**
- `desktop.hyprland` - User Hyprland settings
- `desktop.hyprlock` - Screen locker
- `desktop.i3` - User i3 settings
- `desktop.xdg` - XDG directories

**File Managers:**
- `file-managers.yazi` - TUI file manager
- `file-managers.ranger` - Alternative

**Tools:**
- `tools.eza` - Modern ls replacement
- `tools.bat` - Modern cat replacement
- `tools.fzf` - Fuzzy finder
- `tools.htop` - Process monitor
- `tools.zoxide` - Smart cd

### Enabling/Disabling Modules

All modules have an `enable` option. To use a module:

```nix
# In any configuration file
modules.development.languages.enable = true;
modules.desktop.hyprland.enable = true;
modules.services.docker.enable = true;
```

To disable (default is false):
```nix
modules.desktop.i3.enable = false;
```

---

## Neovim Configuration

### Architecture

**Plugin Count:** 80+ plugins
**Configuration Size:** 1,003 lines (init.lua) + 22 user modules
**Languages Supported:** Lua, Nix, TypeScript, JavaScript, Python, Go, Rust, Java, C/C++, Bash, JSON, YAML, Markdown

### File Structure

```
nvim/
├── init.lua                    # Main entry (leader key, options, keymaps)
├── lua/user/                   # User modules
│   ├── lsp.lua                 # LSP setup (10+ servers)
│   ├── mason.lua               # LSP/formatter installer
│   ├── conform.lua             # Auto-formatting (on save)
│   ├── nvimLint.lua            # Linting
│   ├── telescope.lua           # Fuzzy finder
│   ├── neo-tree.lua            # File explorer
│   ├── harpoon.lua             # Quick file navigation
│   ├── git-conflict.lua        # Merge conflict resolver
│   ├── codeCompanion.lua       # AI assistant (Anthropic)
│   ├── nvimUfo.lua             # Code folding
│   ├── neoscroll.lua           # Smooth scrolling
│   ├── twilight.lua            # Dim inactive code
│   ├── smear-cursor.lua        # Animated cursor
│   ├── visual-enhancements.lua # Lualine, bufferline, dashboard
│   └── [8 more...]
├── plugin/                     # Plugin configs
│   ├── cmp.lua                 # Completion (blink-cmp)
│   ├── dap.lua                 # Debugger (nvim-dap)
│   ├── lsp.lua                 # LSP handlers
│   ├── treesitter.lua          # Syntax parsing
│   ├── telescope.lua           # Telescope setup
│   ├── mini.lua                # Mini.nvim modules
│   └── [5 more...]
├── ftplugin/                   # Filetype-specific
│   ├── lua.lua                 # Lua settings
│   └── nix.lua                 # Nix settings
└── after/                      # Post-load configs
```

### Key Features

1. **LSP Integration** (via nvim-lspconfig + mason)
   - TypeScript/JavaScript (typescript-tools)
   - Lua (lua-ls)
   - Python (pyright)
   - Rust (rust-analyzer)
   - Go (gopls)
   - Java (jdtls)
   - Nix (nil)
   - C/C++ (clangd)
   - And more...

2. **Completion** (blink-cmp)
   - LSP source
   - Buffer source
   - Path source
   - Snippet source (LuaSnip)
   - Fuzzy matching with Rust backend

3. **Treesitter** (nvim-treesitter)
   - 20+ parsers (Lua, Nix, TypeScript, Python, Rust, Java, Go, etc.)
   - Syntax highlighting
   - Code folding
   - Text objects

4. **Git Integration**
   - gitsigns.nvim (inline diffs)
   - vim-fugitive (Git commands)
   - lazygit.nvim (TUI Git client)
   - git-conflict.nvim (3-way merge)

5. **Debugging** (nvim-dap)
   - DAP UI
   - Breakpoints
   - Step debugging
   - Variable inspection
   - REPL

6. **AI Assistant** (codecompanion.nvim)
   - Anthropic/Claude integration
   - Chat interface
   - Code actions
   - Leader key: `<leader>cc` (chat), `<leader>ca` (actions)

7. **File Navigation**
   - Telescope (fuzzy finder)
   - Neo-tree (file explorer)
   - Harpoon2 (quick file marks)
   - Aerial (code outline)

8. **UI Enhancements**
   - Lualine (statusline)
   - Bufferline (buffer tabs)
   - Dashboard (startup screen)
   - Noice (command line UI)
   - Which-key (keybinding hints)

### Important Keybindings

| Key | Action | Plugin |
|-----|--------|--------|
| `<Space>` | Leader key | - |
| `,` | Local leader | - |
| **File Navigation** |||
| `<leader>ff` | Find files | Telescope |
| `<leader>fg` | Live grep | Telescope |
| `<leader>fb` | Find buffers | Telescope |
| `<leader>fo` | Old files | Telescope |
| `<leader>nf` | Find in neo-tree | Neo-tree |
| `<leader>nt` | Toggle neo-tree | Neo-tree |
| **Code** |||
| `gd` | Go to definition | LSP |
| `gr` | Go to references | LSP |
| `K` | Hover docs | LSP |
| `<leader>ca` | Code actions | LSP |
| `<leader>rn` | Rename | LSP |
| `<leader>nn` | Lint + format | conform + nvim-lint |
| **Git** |||
| `<leader>gs` | Git status | Fugitive |
| `<leader>gc` | Git commit | Fugitive |
| `<leader>gg` | LazyGit | LazyGit |
| **Debugging** |||
| `<F1>` | Toggle DAP UI | nvim-dap |
| `<F5>` | Step over | nvim-dap |
| `<F6>` | Continue | nvim-dap |
| `<leader>eb` | Toggle breakpoint | nvim-dap |
| **AI** |||
| `<leader>cc` | Code Companion chat | codecompanion |
| `<leader>ca` | Code Companion actions | codecompanion |
| **Misc** |||
| `<leader>tt` | Toggle terminal | ToggleTerm |
| `<leader>xx` | Diagnostics | Trouble |
| `<leader>a` | Code outline | Aerial |
| `<leader>y` | File manager | Yazi |

### Colorscheme

**Theme:** Eldritch
**Background:** Solid (transparency removed as of 2025-12-12)
**Highlights:** Custom professional styling with rounded borders

---

## Key Configuration Files

### Entry Points

| File | Purpose | Lines |
|------|---------|-------|
| `flake.nix` | Master configuration, defines all hosts and dev shell | ~200 |
| `flake.lock` | Dependency versions (auto-generated) | 1,500+ |
| `lib/default.nix` | Helper functions | ~50 |

### Core Modules

| File | Purpose |
|------|---------|
| `modules/nixos/default.nix` | Aggregates all NixOS modules |
| `modules/home-manager/default.nix` | Aggregates all Home Manager modules |
| `hosts/common/default.nix` | Shared configuration for all hosts |
| `overlays/default.nix` | Custom package overrides |

### Neovim

| File | Purpose | Lines |
|------|---------|-------|
| `nvim/init.lua` | Main Neovim config | 1,003 |
| `packages/neovim/default.nix` | Custom Neovim build | ~300 |
| `nvim/lua/user/*.lua` | User modules (22 files) | ~2,000 total |

### Dotfiles

| Location | Purpose |
|----------|---------|
| `dotfiles/hypr/hyprland.conf` | Hyprland compositor config |
| `dotfiles/ghostty/config` | Ghostty terminal config |
| `dotfiles/configFiles/.zshrc` | Zsh configuration |
| `dotfiles/configFiles/.tmux.conf` | Tmux configuration |

---

## Development Environment

### Supported Languages & Tools

#### Languages

| Language | Version | Package Manager | LSP | Formatter | Linter |
|----------|---------|----------------|-----|-----------|--------|
| **Node.js** | 22 | npm, pnpm, yarn | typescript-tools | prettier | eslint |
| **Python** | 3.12 | pip | pyright | black/ruff | ruff |
| **Go** | Latest | go modules | gopls | gofmt | golangci-lint |
| **Rust** | Stable (rustup) | cargo | rust-analyzer | rustfmt | clippy |
| **Java** | 11, 21, 25 | Maven, Gradle | jdtls | google-java-format | - |
| **C/C++** | GCC, Clang | - | clangd | clang-format | - |
| **Zig** | Latest | zig build | zls | zig fmt | - |
| **Nix** | 2.x | nix-env | nil | alejandra | - |
| **Lua** | 5.1 | luarocks | lua-ls | stylua | luacheck |
| **Bash** | 5.x | - | bash-language-server | shfmt | shellcheck |

#### IDEs & Tools

- **JetBrains:** IntelliJ IDEA, DataGrip
- **Eclipse:** JEE edition
- **Database:** PostgreSQL, DBeaver, vim-dadbod
- **Containers:** Docker, Docker Compose, lazydocker
- **Cloud:** Terraform, kubectl, helm
- **Version Control:** Git, lazygit, gh (GitHub CLI)
- **HTTP Client:** kulala.nvim (in Neovim)

### System Services

| Service | Port(s) | Purpose |
|---------|---------|---------|
| PostgreSQL | 5432 | Database server |
| Docker | - | Container runtime |
| SSH | 22 | Remote access |
| Node dev server | 3000, 5000, 8080-8085 | Web development |
| Observability | 4317-4318 | OTLP endpoints |

### Exposed Firewall Ports

```nix
networking.firewall.allowedTCPPorts = [
  3000 5000 5432 8080 8081 8082 8083 8084 8085 9990 4317 4318
];
```

---

## Build & Deployment

### Building System Configuration

```bash
# Build and activate work machine
sudo nixos-rebuild switch --flake .#work

# Build and activate home machine
sudo nixos-rebuild switch --flake .#home

# Test without activating
sudo nixos-rebuild test --flake .#work

# Build without activating (just create result symlink)
nix build .#nixosConfigurations.work.config.system.build.toplevel
```

### Updating Dependencies

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Run update script (if exists)
./scripts/update.sh
```

### Development Shell

```bash
# Enter dev shell with all tools
nix develop

# Or use direnv (auto-loads)
direnv allow
```

**Provides:**
- Nix formatting: alejandra, nixpkgs-fmt
- Nix LSP: nil
- Lua dev: lua-language-server, stylua, luacheck
- Secrets: sops, age, ssh-to-age

### Garbage Collection

```bash
# Manual GC
nix-collect-garbage -d

# Auto GC (configured)
nix.gc.automatic = true;
nix.gc.dates = "weekly";
nix.gc.options = "--delete-older-than 7d";
```

---

## Common Tasks

### Adding a New Package

**System-wide:**
```nix
# In modules/nixos/development/tools.nix (or create new module)
config = lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [
    new-package-name
  ];
};
```

**User-level:**
```nix
# In modules/home-manager/packages.nix
home.packages = with pkgs; [
  new-package-name
];
```

### Creating a New Module

1. Create file: `modules/nixos/category/new-module.nix`
2. Define options and config:
```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.category.newModule;
in
{
  options.modules.category.newModule = {
    enable = lib.mkEnableOption "new module";
  };

  config = lib.mkIf cfg.enable {
    # Implementation
  };
}
```
3. Import in `modules/nixos/default.nix`:
```nix
imports = [
  # ...
  ./category/new-module.nix
];
```
4. Enable in `hosts/common/default.nix` or host-specific config:
```nix
modules.category.newModule.enable = true;
```

### Adding a New Host

1. Create directory: `hosts/new-host/`
2. Generate hardware config:
```bash
nixos-generate-config --show-hardware-config > hosts/new-host/hardware-configuration.nix
```
3. Create `hosts/new-host/default.nix`:
```nix
{ ... }: {
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "new-host";
  # Host-specific overrides
}
```
4. Add to `flake.nix`:
```nix
nixosConfigurations.new-host = lib.nixosSystem {
  # ...
};
```

### Adding a Neovim Plugin

**In `packages/neovim/default.nix`:**
```nix
plugins = with pkgs.vimPlugins; [
  # ...
  new-plugin-name
];
```

**Configure in `nvim/lua/user/new-plugin.lua`:**
```lua
require('new-plugin').setup({
  -- Configuration
})
```

**Source in `nvim/init.lua`:**
```lua
require('user.new-plugin')
```

### Managing Secrets

```bash
# Edit secrets file
sops secrets/secrets.yaml

# Add new secret in secrets.yaml:
# example_secret: my_value

# Reference in Nix:
sops.secrets.example_secret = {
  owner = "hubert";
  path = "/run/secrets/example_secret";
};
```

### Git Workflow

```bash
# Working branch
git checkout dev

# Make changes, test
sudo nixos-rebuild test --flake .#work

# Commit (from Neovim: <leader>gs, or CLI)
git add .
git commit -m "description"

# Merge to master when stable
git checkout master
git merge dev
git push origin master
```

---

## Technical Specifications

### System Information

| Spec | Value |
|------|-------|
| **OS** | NixOS (Linux 6.12.59) |
| **Nix Version** | 2.x (flakes enabled) |
| **Init System** | systemd |
| **Bootloader** | systemd-boot or GRUB |
| **Display Server** | Wayland (Hyprland) / X11 (i3) |
| **Display Manager** | SDDM |
| **Audio** | Pipewire |
| **File System** | ext4/btrfs (hardware-dependent) |

### Network Configuration

```nix
networking = {
  networkmanager.enable = true;
  nameservers = [ "1.1.1.1" "8.8.8.8" ];  # Cloudflare + Google
  firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 5000 5432 8080-8085 9990 4317 4318 ];
  };
};
```

### User Configuration

| User | Groups | Shell | Home |
|------|--------|-------|------|
| hubert | wheel, networkmanager, docker, audio | zsh | /home/hubert |

### File Statistics

| Metric | Count |
|--------|-------|
| Total Nix files | 77 |
| NixOS modules | 45 |
| Home Manager modules | 32 |
| Neovim Lua files | 38 |
| Shell scripts | 19 |
| Neovim plugins | 80+ |
| Total config lines (init.lua) | 1,003 |

### Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | Main package repository (unstable channel) |
| `home-manager` | User environment management |
| `sops-nix` | Secrets encryption |
| `gen-luarc` | Lua LSP for Neovim plugin dev |
| `eldritch-nvim` | Custom colorscheme |

### Resource Paths

| Resource | Path |
|----------|------|
| System config | `/etc/nixos` |
| User config | `/home/hubert/.config` |
| Neovim config | `/home/hubert/.config/nvim` |
| SOPS key | `/home/hubert/.config/sops/age/keys.txt` |
| Home Manager | `/home/hubert/.config/home-manager` |

---

## Important Context for AI Assistants

### When Helping with This Codebase

1. **Always check module options first** - Use the options pattern, don't hardcode
2. **Maintain modularity** - New features should be new modules with `enable` flags
3. **Respect the architecture** - Don't break the NixOS/Home Manager separation
4. **Test on dev branch first** - Never directly modify master
5. **Use the custom Neovim build** - Don't suggest installing plugins outside the Nix package
6. **Consider both hosts** - Changes in `common/` affect work and home
7. **Follow existing patterns** - Look at similar modules for reference
8. **Preserve type safety** - Always define option types
9. **Document new options** - Use `description` fields
10. **Keep secrets encrypted** - Never expose secrets in Nix files

### Common Pitfall Avoidance

❌ **Don't:**
- Modify `/etc/nixos/configuration.nix` directly (use flake modules)
- Install packages with `nix-env` (use modules)
- Add system packages to Home Manager (use NixOS modules)
- Hardcode paths (use variables and options)
- Skip the `enable` option (always add it)

✅ **Do:**
- Use the module system
- Define options with types
- Test before committing
- Keep configurations declarative
- Use overlays for custom packages

### Module Naming Conventions

- **Options:** `modules.<category>.<name>.enable`
- **Files:** `modules/nixos/<category>/<name>.nix`
- **Let bindings:** `cfg = config.modules.<category>.<name>`

### Debugging Tips

```bash
# Check option values
nixos-option modules.development.languages

# Validate flake
nix flake check

# Show build trace
nixos-rebuild switch --flake .#work --show-trace

# Evaluate Nix expression
nix eval .#nixosConfigurations.work.config.system.build.toplevel
```

---

## Quick Reference

### Rebuild Commands
```bash
sudo nixos-rebuild switch --flake .#work  # Work machine
sudo nixos-rebuild switch --flake .#home  # Home machine
sudo nixos-rebuild test --flake .#work    # Test without boot
```

### Neovim Leader Keys
- Primary leader: `<Space>`
- Local leader: `,`

### Important Directories
- System config: `modules/nixos/`
- User config: `modules/home-manager/`
- Host configs: `hosts/`
- Neovim: `nvim/`
- Scripts: `scripts/`

### Helpful Commands
```bash
nix flake update                  # Update all inputs
nix develop                       # Enter dev shell
nix-collect-garbage -d            # Clean old generations
nixos-rebuild list-generations    # List system versions
sops secrets/secrets.yaml         # Edit secrets
```

---

**Last Updated:** 2025-12-12
**Repository:** /home/hubert/nixos
**Current Branch:** dev
**Main Branch:** master
**Git Status:** Clean working tree
