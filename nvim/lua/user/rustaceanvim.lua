-- rustaceanvim — rust-analyzer wrapper + cargo runnables/testables/debuggables.
--
-- NOTE: rust_analyzer is intentionally NOT registered in plugin/lsp.lua's servers
-- table; rustaceanvim owns the rust-analyzer client. Do NOT also call
-- lspconfig.rust_analyzer.setup() — double-attach breaks runnables.
--
-- Required from lz.n's `after` hook (plugin/lazy-load.lua) — post-packadd so
-- require("rustaceanvim.config") resolves for the codelldb adapter. lz.n re-fires
-- the FileType event afterwards, so vim.g.rustaceanvim is set before LSP start.

local on_attach = require("user.lsp-on-attach")

-- Reuse blink.cmp capabilities so Rust completion matches every other server.
-- blink-cmp is eager (packages/neovim/plugins.nix), so this require is safe here.
local ok_blink, blink = pcall(require, "blink.cmp")

-- Build the full opts table first, then assign vim.g.rustaceanvim ONCE.
-- Reading vim.g.rustaceanvim returns a copy, so `vim.g.rustaceanvim.dap = ...`
-- after assignment would be silently dropped — everything must go in here.
local opts = {
	server = {
		capabilities = ok_blink and blink.get_lsp_capabilities() or nil,
		on_attach = function(client, bufnr)
			-- Keep the shared LSP maps (gd / gD / gi / K / [d]d / [e]e / <leader>ee / gs).
			on_attach(client, bufnr)

			local function map(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
			end

			-- BANG (`RustLsp! run`) = execute_last_runnable: first press opens the
			-- picker and caches the choice; every press after re-runs that target
			-- from ANY cursor position (no "no runnable at position" error). This is
			-- the <leader>tt → type `cargo run` replacement. Output in a terminal split.
			map("<leader>rr", function() vim.cmd.RustLsp({ "run", bang = true }) end, "Rust: run (last runnable)")
			-- No bang = always re-open the picker, to switch which target runs.
			map("<leader>rR", function() vim.cmd.RustLsp("runnables") end, "Rust: pick runnable")
			map("<leader>rt", function() vim.cmd.RustLsp({ "testables", bang = true }) end, "Rust: test (last)")
			map("<leader>rd", function() vim.cmd.RustLsp({ "debuggables", bang = true }) end, "Rust: debug (last)")
			map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Rust: expand macro")
			map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Rust: open Cargo.toml")
			-- rustaceanvim's richer hover with grouped code actions (overrides plain K).
			map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Rust: hover actions")
		end,
		default_settings = {
			["rust-analyzer"] = {
				-- clippy on save instead of plain `cargo check` — richer lints.
				checkOnSave = true,
				check = { command = "clippy" },
				-- targetDir = true → RA builds into target/rust-analyzer/ instead of
				-- sharing target/ with terminal cargo. Prevents "compiled by an
				-- incompatible version of rustc" thrash: system RA/clippy is nixpkgs
				-- stable, terminal cargo is rustup nightly — same target/ means each
				-- rejects the other's .rmeta artifacts.
				cargo = { allFeatures = true, buildScripts = { enable = true }, targetDir = true },
				procMacro = { enable = true },
			},
		},
	},
}

-- DAP: wire codelldb from the nix-provided extension (CODELLDB_PATH set in
-- modules/home-manager/default.nix). Without it, <leader>rd / debuggables fall
-- back to rustaceanvim's auto-detection (Mason / PATH) — usually nothing on NixOS.
local ext = vim.env.CODELLDB_PATH
if ext and ext ~= "" then
	local codelldb = ext .. "/adapter/codelldb"
	local liblldb = ext .. "/lldb/lib/liblldb.so"
	if vim.fn.filereadable(codelldb) == 1 and vim.fn.filereadable(liblldb) == 1 then
		local ok_cfg, rcfg = pcall(require, "rustaceanvim.config")
		if ok_cfg then
			opts.dap = { adapter = rcfg.get_codelldb_adapter(codelldb, liblldb) }
		end
	end
end

vim.g.rustaceanvim = opts
