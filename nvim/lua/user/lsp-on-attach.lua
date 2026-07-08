-- Shared LSP on_attach: common buffer-local keymaps + diagnostics navigation.
-- Used by plugin/lsp.lua for every server AND by user/rustaceanvim.lua, so Rust
-- buffers keep the same gd/gD/gi/K/[d]d/[e]e/<leader>ca/<leader>cd/gs maps even
-- though rustaceanvim (not the lsp.lua servers table) owns the rust-analyzer
-- client. Namespace registry: user/keymaps.lua.
return function(client, bufnr)
	local function bufmap(mode, keys, fn, desc)
		vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
	end

	-- Inlay hints — servers are configured to send them (plugin/lsp.lua), so
	-- turn them on. The big-file guard in ftplugin/java.lua runs on the later
	-- LspAttach autocmd, so it still wins for large Java buffers.
	if client and client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
	bufmap("n", "<leader>uh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, "Toggle inlay hints")

	-- Navigation (vim/Helix goto convention: g = go)
	bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
	bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	bufmap("n", "K", vim.lsp.buf.hover, "Hover documentation")

	-- Code actions & diagnostics (<leader>c = code)
	bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
	bufmap("n", "<leader>cd", function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end, "Line diagnostics")

	-- Diagnostics navigation (unimpaired-style bracket pairs)
	bufmap("n", "[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, "Previous diagnostic")
	bufmap("n", "]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, "Next diagnostic")
	bufmap("n", "[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	end, "Previous error")
	bufmap("n", "]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	end, "Next error")

	-- Telescope loads on DeferredUIEnter (opt plugin) — resolve at keypress,
	-- not at startup, so this file doesn't force-load it.
	bufmap("n", "gs", function()
		local ok, builtin = pcall(require, "telescope.builtin")
		if ok then
			builtin.lsp_document_symbols()
		else
			vim.notify("Telescope not loaded yet", vim.log.levels.WARN)
		end
	end, "Go to document symbol")
end
