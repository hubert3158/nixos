-- Shared LSP on_attach: common buffer-local keymaps + diagnostics navigation.
-- Used by plugin/lsp.lua for every server AND by user/rustaceanvim.lua, so Rust
-- buffers keep the same gd/gD/gi/K/[d]d/[e]e/<leader>ee/gs maps even though
-- rustaceanvim (not the lsp.lua servers table) owns the rust-analyzer client.
return function(client, bufnr)
	local function bufmap(keys, fn)
		vim.keymap.set("n", keys, fn, { buffer = bufnr })
	end

	-- Inlay hints — servers are configured to send them (plugin/lsp.lua), so
	-- turn them on. The big-file guard in ftplugin/java.lua runs on the later
	-- LspAttach autocmd, so it still wins for large Java buffers.
	if client and client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
	bufmap("<leader>th", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end)

	-- Navigation
	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gi", vim.lsp.buf.implementation)
	bufmap("K", vim.lsp.buf.hover)

	-- Diagnostics navigation
	bufmap("[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end)
	bufmap("]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end)
	bufmap("[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	end)
	bufmap("]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	end)
	bufmap("<leader>ee", function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end)

	-- Telescope loads on DeferredUIEnter (opt plugin) — resolve at keypress,
	-- not at startup, so this file doesn't force-load it.
	bufmap("gs", function()
		local ok, builtin = pcall(require, "telescope.builtin")
		if ok then
			builtin.lsp_document_symbols()
		else
			vim.notify("Telescope not loaded yet", vim.log.levels.WARN)
		end
	end)
end
