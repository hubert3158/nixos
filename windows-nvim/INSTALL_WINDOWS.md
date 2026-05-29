# Install guide — Neovim on Windows

This config is a Windows-native port of a NixOS Neovim setup. **lazy.nvim** installs
and lazy-loads the plugins (it bootstraps itself on first launch); **mason.nvim** +
a few `scoop` packages provide the LSP servers, formatters, linters and CLI tools.

Work top to bottom. Steps 1–4 get you a fully working editor; step 5 is optional
language toolchains; step 6 lists the per-feature gotchas.

---

## 1. Core tools (required)

In PowerShell:

```powershell
# Scoop (skip if you already have it)
irm get.scoop.sh | iex
scoop bucket add extras
scoop bucket add nerd-fonts

# The essentials this config needs at runtime
scoop install neovim git ripgrep fd gcc make cmake tree-sitter nodejs-lts lazygit yazi JetBrainsMono-NF
```

What each is for:
- **neovim** (0.10+, you have 0.12) — the editor.
- **git** — lazy.nvim clones plugins with it.
- **ripgrep (rg)** + **fd** — Telescope file/grep search.
- **tree-sitter** — CLI used by nvim-treesitter (main branch) to compile parsers.
- **gcc (mingw)** + **make** + **cmake** — C/C++ compilers. gcc's g++ is required to build
  Treesitter parsers that have C++ scanners (typescript, tsx, markdown); cmake/make build `telescope-fzf-native`.
- **nodejs-lts** — markdown-preview and several LSP servers.
- **lazygit** — the `<leader>gg` git UI.
- **yazi** — the `<leader>y` file manager.
- **JetBrainsMono-NF** — a Nerd Font for icons. **After installing, set your
  terminal's font to "JetBrainsMono Nerd Font"** or every icon shows as tofu.

Then **close and reopen PowerShell** so the new tools are on `PATH`.

---

## 2. Install this config

It must live at `%LOCALAPPDATA%\nvim` (= `C:\Users\<you>\AppData\Local\nvim`).
If you're reading this file, it's already there. If you ever need to redo it:

```powershell
$dest = "$env:LOCALAPPDATA\nvim"
if (Test-Path $dest) { Rename-Item $dest "$dest.bak" }
Copy-Item -Recurse -Force "$env:USERPROFILE\Documents\projects\nixos\windows-nvim\*" $dest\
```

`init.lua` must sit directly at `...\nvim\init.lua` (not nested in a sub-folder).

---

## 3. First launch — plugins & parsers

```powershell
nvim
```

On first run it clones lazy.nvim, then downloads every plugin. Let it finish, then
inside Neovim:

```vim
:Lazy sync                              " install/update all plugins
:TSUpdate                               " compile Treesitter parsers (uses gcc)
:Lazy build telescope-fzf-native.nvim   " build the native fuzzy sorter (uses cmake)
```

Restart Neovim once afterward.

- **blink.cmp** downloads a prebuilt fuzzy binary automatically — no Rust needed.
- If `telescope-fzf-native` still won't build, it's harmless: Telescope falls back
  to its Lua sorter (the config no longer crashes if the native lib is missing).

---

## 4. LSP servers, formatters & linters (via Mason)

Run this once inside Neovim. Mason puts everything on Neovim's `PATH`, so the
servers in `plugin/lsp.lua` find themselves:

```vim
:MasonInstall lua-language-server vscode-langservers-extracted eslint-lsp bash-language-server clangd pyright marksman sqls rust-analyzer yaml-language-server stylua prettierd prettier shfmt taplo clang-format isort black goimports sqlfluff shellcheck yamllint hadolint htmlhint flake8 tflint eslint_d
```

Check progress with `:Mason`. Tools and what needs them:

| Category | Tools | Needs on PATH |
|---|---|---|
| LSP servers | lua_ls, html/css/json, bashls, clangd, pyright, marksman, sqls, rust_analyzer, yaml | node (most), nothing extra |
| Formatters (conform) | stylua, prettierd/prettier, shfmt, taplo, clang-format, goimports, sqlfluff, **isort, black** | goimports→Go, isort/black→**Python** |
| Linters (nvim-lint) | shellcheck, yamllint, hadolint, htmlhint, tflint, eslint_d, sqlfluff, **flake8** | flake8→**Python** |

---

## 5. Optional language toolchains

Install only the ones you actually use — your `:checkhealth` flagged these as
missing, which is fine until you need them:

```powershell
scoop install python      # REQUIRED for black, isort, flake8 (Python formatting/linting)
scoop install go          # for goimports / gofmt (Go formatting)
scoop install rust        # for rustfmt, and to build codesnap.nvim
scoop install gzip unzip wget   # silences Mason "core utils" warnings; rarely needed
```

> Windows note: if `python` opens the Microsoft Store instead of running, turn off
> the alias in **Settings → Apps → Advanced app settings → App execution aliases**
> (disable the `python.exe` / `python3.exe` entries), then `scoop install python`.

**Java / jdtls (only if you write Java).** The Java LSP is wrapped so it stays
completely silent when Java isn't set up — no startup errors. To enable it:
1. Install a JDK (e.g. `scoop install temurin21-jdk`).
2. Set an environment variable pointing at it — the config reads `JAVA_HOME21`
   (also accepts `JAVA_HOME11` / `JAVA_HOME25`):
   ```powershell
   setx JAVA_HOME21 "C:\Users\<you>\scoop\apps\temurin21-jdk\current"
   ```
3. `:MasonInstall jdtls java-debug-adapter java-test`, then restart Neovim.

---

## 6. Per-feature notes (things that need a one-time tweak)

**CodeCompanion (AI).** `lua/user/codeCompanion.lua` was written for NixOS — it
pulls API keys via `gpg`/`pass`, which doesn't exist on Windows. Edit that file and
change each adapter's `env.api_key` to an environment-variable name, e.g.
`api_key = "ANTHROPIC_API_KEY"`, then `setx ANTHROPIC_API_KEY "sk-..."`. Until then
the AI commands error only when invoked; nothing else is affected.

**codesnap.nvim** builds a Rust generator (`make build_generator`) — needs `cargo`
**and** `make` (`scoop install rust make`). If you don't want it, delete the
`codesnap.nvim` block from `lua/plugins.lua`.

**JS/TS debugging (nvim-dap).** The NixOS debug-adapter paths were replaced with
Mason lookups. To debug JavaScript: `:MasonInstall js-debug-adapter` (and
`firefox-debug-adapter` if you debug in Firefox). Without them, only debugging is
affected — startup is clean.

**tmux plugins.** `vim-tmux-navigator` and `vim-slime` (`g.slime_target = "tmux"`)
do nothing without tmux. Harmless; remove if you like.

**Telescope frecency** has a leftover Linux workspace bookmark in
`plugin/telescope.lua` (`/home/hubert/nixos`) — cosmetic; CWD search works regardless.

---

## Troubleshooting

**Treesitter: "destination path 'tree-sitter-XXX' already exists" / parser won't compile.**
Parsers with a C++ scanner (typescript, tsx, markdown, …) need a C++ compiler. zig
alone isn't reliable for them — install gcc (`scoop install gcc make`), which gives
g++. When a compile fails it leaves a half-cloned folder that blocks retries, so
clear those, then reinstall:
```powershell
# close Neovim first, then:
Get-ChildItem -Path "$env:LOCALAPPDATA\nvim-data","$env:TEMP","$HOME" -Recurse -Directory -Filter "tree-sitter-*" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
```
Reopen Neovim and run `:TSUpdate` (let it finish without quitting mid-download).

**`vscode-eslint-language-server ... failed`** — install the server: `:MasonInstall eslint-lsp`.

**`telescope-fzf-native not built (libfzf)`** — harmless (Telescope falls back to its Lua
sorter). To enable the fast native sorter, install gcc/make as above, then run
`:Lazy build telescope-fzf-native.nvim`.

## 7. Verify

```vim
:checkhealth        " review; disabled python/ruby/perl/node PROVIDERS are intentional
:Lazy               " all plugins installed
:Mason              " your servers/formatters/linters present
```

## Updating later

```vim
:Lazy sync          " update plugins
:MasonUpdate        " update Mason's registry
```

lazy.nvim writes `lazy-lock.json` into this folder — commit it for reproducible
plugin versions across machines.
