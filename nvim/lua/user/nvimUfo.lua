-- zR/zM must go through ufo — native versions change foldlevel, which ufo
-- fights (folds snap back). za/zo/zc/zO work natively.
vim.keymap.set("n", "zR", function()
	require("ufo").openAllFolds()
end, { desc = "Open all folds (ufo)" })
vim.keymap.set("n", "zM", function()
	require("ufo").closeAllFolds()
end, { desc = "Close all folds (ufo)" })

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		-- Skip special buffers (diffview panels, terminals, prompts, nofile).
		-- ufo's decoration provider reads stale line counts on buffers that
		-- plugins rewrite wholesale → "index out of bounds" spam on redraw.
		if buftype ~= "" or filetype == "" then
			return ""
		end
		return { "treesitter", "indent" }
	end,
})

-- Diffview file buffers are real files but get rewritten on every view
-- refresh — detach ufo there too (folding in a diff split is useless anyway).
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UfoDetachDiffview", { clear = true }),
	pattern = { "DiffviewFiles", "DiffviewFileHistory" },
	callback = function(args)
		pcall(require("ufo").detach, args.buf)
	end,
})
