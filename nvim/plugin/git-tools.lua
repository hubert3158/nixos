-- Git Conflict Resolution
require("git-conflict").setup({
	default_mappings = true, -- disable buffer local mapping created by this plugin
	default_commands = true, -- disable commands created by this plugin
	disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
	list_opener = "copen", -- command or function to open the conflicts list
	highlights = { -- They must have background color, otherwise the default color will be used
		incoming = "DiffAdd",
		current = "DiffText",
	},
})

-- Better Quickfix
require("bqf").setup({
	auto_enable = true,
	auto_resize_height = true, -- highly recommended enable
	preview = {
		win_height = 12,
		win_vheight = 12,
		delay_syntax = 80,
		border_chars = { "┃", "━", "┏", "┓", "┗", "┛", "━", "┃", "█" },
		should_preview_cb = function(bufnr, qwinid)
			local ret = true
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local fsize = vim.fn.getfsize(bufname)
			if fsize > 100 * 1024 then
				-- skip file size greater than 100k
				ret = false
			elseif bufname:match("^fugitive://") then
				-- skip fugitive buffer
				ret = false
			end
			return ret
		end,
	},
	-- make `drop` and `tab drop` to become preferred
	func_map = {
		drop = "o",
		openc = "O",
		split = "<C-s>",
		tabdrop = "<C-t>",
		tabc = "",
		ptogglemode = "z,",
	},
	filter = {
		fzf = {
			action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
			extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
		},
	},
})

-- Keymaps for git conflicts
vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "Choose ours" })
vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "Choose theirs" })
vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "Choose both" })
vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "Choose none" })
vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" })
vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })