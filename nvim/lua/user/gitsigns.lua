-- gitsigns — hunk signs + buffer-local hunk keymaps.
-- <leader>g = git group (namespace registry: user/keymaps.lua); [h ]h follow
-- the unimpaired-style bracket-pair convention.
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
		end

		map("n", "]h", function()
			gs.nav_hunk("next")
		end, "Next git hunk")
		map("n", "[h", function()
			gs.nav_hunk("prev")
		end, "Previous git hunk")

		map({ "n", "v" }, "<leader>ga", gs.stage_hunk, "Stage hunk")
		map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
		map("n", "<leader>gv", gs.preview_hunk, "Preview hunk")
		map("n", "<leader>gb", gs.blame_line, "Blame line")
	end,
})
