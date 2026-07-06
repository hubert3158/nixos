# Neovim plugins list
#
# Built on top of the kickstart-nix.nvim template:
#   https://github.com/nix-community/kickstart-nix.nvim
#
# `optional = true` puts a plugin in pack/*/opt — it is NOT sourced at
# startup; lz.n (nvim/plugin/lazy-load.lua) packadds it on its trigger.
# Every optional plugin here MUST have a matching lz.n spec whose name
# equals the plugin's pname (= pack directory name).
{ pkgs, inputs }:

let
  # Patch away nvim 0.13+ deprecations that upstream hasn't fixed yet
  # (checkhealth vim.deprecated). extend() rewrites the fixed point, so
  # plugins that depend on these (e.g. neotest → nvim-nio) pick up the
  # patched versions too. Drop once upstream releases catch up.
  vimPlugins = pkgs.vimPlugins.extend (final: prev: {
    # client.request → client:request (removed in nvim 0.13; hit by
    # rustaceanvim's neotest adapter through nio.lsp)
    nvim-nio = prev.nvim-nio.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace lua/nio/lsp.lua \
          --replace-fail "client.request(method, params, cb, bufnr)" "client:request(method, params, cb, bufnr)"
      '';
      # test suite stubs clients with plain tables that expect the old
      # dot-call signature — real nvim clients accept both
      doCheck = false;
    });
    # vim.highlight → vim.hl (removed in nvim 2.0)
    git-conflict-nvim = prev.git-conflict-nvim.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace lua/git-conflict.lua \
          --replace-fail "vim.highlight.priorities.user" "vim.hl.priorities.user"
      '';
    });
    # ufo's decoration provider works off a cached buffer model that goes
    # stale when buffers change under it (notify animation floats, noice
    # redraws, undo, diffview refreshes). Any error inside the render hook is
    # re-raised by silentOnEnd (decorator.lua:148) on EVERY redraw → endless
    # "Decoration provider end (ns=ufo)" spam. Patching individual crash
    # sites is whack-a-mole (buffer.lua assert → render/init.lua nil text →
    # ...), so mute the re-raise itself: onEnd is pure decoration, silently
    # skipping a frame on a stale buffer is invisible.
    nvim-ufo = prev.nvim-ufo.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace lua/ufo/decorator.lua \
          --replace-fail "error(msg, 0)" "do end -- swallowed: stale-buffer decoration errors are cosmetic"
      '';
    });
  });
in
{
  all-plugins = with vimPlugins; [
    # ============================================================================
    # CORE DEPENDENCIES
    # ============================================================================
    plenary-nvim
    nui-nvim
    lz-n

    # ============================================================================
    # COLORSCHEME & UI
    # ============================================================================
    # kanagawa setup lives in nvim/init.lua (single source of truth).
    # Matches the helix theme (modules/home-manager/programs/helix.nix).
    kanagawa-nvim
    { plugin = lualine-nvim; optional = true; }
    # bufferline setup runs inside user/visual-enhancements.setup() (lualine's
    # DeferredUIEnter hook packadds it first).
    { plugin = bufferline-nvim; optional = true; }
    { plugin = dashboard-nvim; }
    # noice setup lazy via lz.n on DeferredUIEnter (+ overrides for vim.lsp.util).
    { plugin = noice-nvim; optional = true; }
    {
      plugin = nvim-web-devicons;
      config = "lua << EOF\nrequire(\"nvim-web-devicons\").setup()\nEOF\n";
    }
    { plugin = nvim-notify; }
    # barbecue (winbar breadcrumbs) — lazy via lz.n on DeferredUIEnter.
    { plugin = barbecue-nvim; optional = true; }
    # indent-blankline / colorizer / smartcolumn — setup lazy via lz.n.
    { plugin = indent-blankline-nvim; optional = true; }
    { plugin = nvim-colorizer-lua; optional = true; }
    { plugin = smear-cursor-nvim; optional = true; }
    { plugin = twilight-nvim; optional = true; }
    { plugin = smartcolumn-nvim; optional = true; }

    # ============================================================================
    # FILE MANAGEMENT & NAVIGATION
    # ============================================================================
    # telescope + extensions load on DeferredUIEnter (user/telescope.lua
    # packadds the extensions before setup).
    { plugin = telescope-nvim; optional = true; }
    { plugin = telescope-symbols-nvim; optional = true; }
    { plugin = telescope-zoxide; optional = true; }
    { plugin = telescope-fzf-native-nvim; optional = true; }
    { plugin = telescope-frecency-nvim; optional = true; }
    # neo-tree loads via lz.n on cmd=Neotree / the dir-open autocmd; its
    # window-picker dep is packadd'ed + configured in the same lz.n hook.
    { plugin = neo-tree-nvim; optional = true; }
    { plugin = yazi-nvim; optional = true; }
    { plugin = harpoon2; optional = true; }
    { plugin = nvim-window-picker; optional = true; }
    vim-tmux-navigator

    # ============================================================================
    # GIT INTEGRATION
    # ============================================================================
    # gitsigns setup lazy via lz.n on BufReadPre/BufNewFile.
    { plugin = gitsigns-nvim; optional = true; }
    { plugin = vim-fugitive; optional = true; }
    { plugin = lazygit-nvim; optional = true; }
    # diffview — PR review / file history; lazy via lz.n on its commands.
    { plugin = diffview-nvim; optional = true; }
    # octo — GitHub PRs/issues via gh CLI; lazy via lz.n on cmd=Octo.
    { plugin = octo-nvim; optional = true; }
    # git-conflict setup runs lazily via nvim/lua/user/git-conflict.lua
    # (driven by lz.n on DeferredUIEnter).
    { plugin = git-conflict-nvim; optional = true; }

    # ============================================================================
    # LSP & LANGUAGE SUPPORT
    # ============================================================================
    { plugin = nvim-lspconfig; }
    # mason-nvim removed — all LSPs and jdtls bundles now come from nixpkgs.
    # lazydev — lazy via lz.n on ft=lua.
    { plugin = lazydev-nvim; optional = true; }
    # typescript-tools.nvim replaced by vtsls (registered via lsp.lua) —
    # plugin had breakage on nvim 0.12 vim.lsp.enable wire-up (issue #379).
    nvim-jdtls
    # rustaceanvim owns the rust-analyzer client (do NOT also register it in
    # plugin/lsp.lua). Config + keymaps: nvim/lua/user/rustaceanvim.lua, loaded
    # lazily on ft=rust via lz.n (nvim/plugin/lazy-load.lua).
    { plugin = rustaceanvim; optional = true; }
    # fidget (LSP progress UI) — lazy via lz.n on LspAttach.
    { plugin = fidget-nvim; optional = true; }
    nvim-navic
    # inc-rename — live rename preview (noice renders it inline); lazy on cmd.
    { plugin = inc-rename-nvim; optional = true; }

    # ============================================================================
    # AUTOCOMPLETION & SNIPPETS
    # ============================================================================
    # blink-cmp must stay eager: plugin/lsp.lua derives LSP client
    # capabilities from it at startup.
    blink-cmp
    luasnip
    friendly-snippets
    # vim-snippets removed — snipMate-format; only the vscode loader
    # (friendly-snippets) is wired in plugin/cmp.lua, so it contributed nothing.

    # ============================================================================
    # TREESITTER & SYNTAX HIGHLIGHTING
    # ============================================================================
    (nvim-treesitter.withPlugins (p: [
      p.vimdoc p.rust p.pug p.vim p.javascript p.typescript p.tsx
      p.csv p.json p.c p.query p.lua p.java p.nix p.luadoc
      p.markdown p.markdown_inline p.yuck p.zig p.http p.graphql p.yaml p.typst
    ]))
    nvim-ts-autotag
    nvim-ts-context-commentstring
    # textobjects queries (queries/*/textobjects.scm) — consumed by mini.ai's
    # treesitter spec (user/mini.lua); no setup call needed.
    nvim-treesitter-textobjects
    # sticky current-function header while scrolling; lazy on BufReadPre.
    { plugin = nvim-treesitter-context; optional = true; }
    # muted kanagawa-toned bracket pairs (RainbowDelimiter* groups defined in
    # the kanagawa overrides, nvim/init.lua); lazy on BufReadPre.
    { plugin = rainbow-delimiters-nvim; optional = true; }

    # ============================================================================
    # CODE EDITING & REFACTORING
    # ============================================================================
    {
      plugin = comment-nvim;
      config = "lua << EOF\nrequire(\"Comment\").setup()\nEOF\n";
    }
    comment-box-nvim # no config anywhere — used ad hoc via :CB* or candidate for removal
    # refactoring.nvim removed: as of nixpkgs 2026-04 it depends on async.nvim,
    # which ships a top-level lua/async.lua that collides with promise-async
    # and breaks nvim-ufo's require('async'). LSP code actions cover most of
    # what refactoring.nvim offered. Re-evaluate once upstream resolves the
    # naming collision.
    vim-visual-multi
    { plugin = yanky-nvim; }
    # grug-far — ripgrep-backed search/replace with live preview (replaced
    # nvim-spectre: stale, sed-based apply). Lazy via lz.n on keys/cmd.
    { plugin = grug-far-nvim; optional = true; }
    { plugin = venn-nvim; optional = true; }
    vim-easy-align

    # ============================================================================
    # FORMATTING & LINTING
    # ============================================================================
    { plugin = conform-nvim; optional = true; }
    { plugin = nvim-lint; optional = true; }

    # ============================================================================
    # DEBUGGING
    # ============================================================================
    { plugin = nvim-dap; optional = true; }
    { plugin = nvim-dap-ui; optional = true; }
    # inline variable values while stepping — packadd'ed in user/dap.lua.
    { plugin = nvim-dap-virtual-text; optional = true; }
    { plugin = debugprint-nvim; optional = true; }

    # ============================================================================
    # TESTING (neotest — run/debug tests inline)
    # ============================================================================
    # nvim-nio is neotest's async runtime — eager lib, like promise-async.
    nvim-nio
    { plugin = neotest; optional = true; }
    # adapters are packadd'ed in user/neotest.lua before setup; the rust
    # adapter ships inside rustaceanvim (rustaceanvim.neotest).
    { plugin = neotest-java; optional = true; }
    { plugin = neotest-jest; optional = true; }
    { plugin = neotest-vitest; optional = true; }

    # ============================================================================
    # UTILITIES & PRODUCTIVITY
    # ============================================================================
    { plugin = which-key-nvim; }
    # toggleterm — lazy via lz.n (cmd/keys); full config in user/toggleterm.lua.
    { plugin = toggleterm-nvim; optional = true; }
    # trouble — lazy via lz.n on cmd=Trouble.
    { plugin = trouble-nvim; optional = true; }
    { plugin = undotree; optional = true; }
    # auto-session stays eager — session restore must be configured before
    # VimEnter; init.lua requires user/auto-session.lua directly.
    auto-session
    { plugin = todo-comments-nvim; optional = true; }
    { plugin = neoscroll-nvim; optional = true; }
    # quicker — editable, syntax-highlighted quickfix; lazy on DeferredUIEnter.
    { plugin = quicker-nvim; optional = true; }
    # overseer — task runner (build/watch/scripts) with dap integration.
    { plugin = overseer-nvim; optional = true; }
    # neogen — lazy via lz.n on its <leader>nc key.
    { plugin = neogen; optional = true; }

    # ============================================================================
    # CODE FOLDING & STRUCTURE
    # ============================================================================
    { plugin = nvim-ufo; optional = true; }
    promise-async
    # aerial — lazy via lz.n on its commands.
    { plugin = aerial-nvim; optional = true; }

    # ============================================================================
    # AI & CODE ASSISTANCE
    # ============================================================================
    { plugin = codecompanion-nvim; optional = true; }

    # ============================================================================
    # DATABASE MANAGEMENT
    # ============================================================================
    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion

    # ============================================================================
    # HTTP & API TESTING
    # ============================================================================
    { plugin = kulala-nvim; optional = true; }

    # ============================================================================
    # DOCUMENTATION & MARKDOWN
    # ============================================================================
    # markdown-preview (node-backed, heavy) — lazy via lz.n on ft=markdown.
    { plugin = markdown-preview-nvim; optional = true; }
    { plugin = render-markdown-nvim; optional = true; }

    # ============================================================================
    # SCREENSHOTS & SHARING
    # ============================================================================
    { plugin = codesnap-nvim; optional = true; }

    # ============================================================================
    # LANGUAGE-SPECIFIC PLUGINS
    # ============================================================================
    vim-pug
    vim-nix
    vim-slime
    # typst-preview — lazy via lz.n on ft=typst.
    { plugin = typst-preview-nvim; optional = true; }

    # ============================================================================
    # MINI PLUGINS COLLECTION
    # ============================================================================
    { plugin = mini-nvim; optional = true; }
  ];
}
