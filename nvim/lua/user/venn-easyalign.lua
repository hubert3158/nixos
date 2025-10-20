-- Venn.nvim (ASCII drawing) keybindings
-- Official venn.nvim toggle function (from documentation)
function _G.Toggle_venn()
	local venn_enabled = vim.inspect(vim.b.venn_enabled)
	if venn_enabled == "nil" then
		vim.b.venn_enabled = true
		vim.cmd([[setlocal ve=all]])
		-- draw a line on HJKL keystokes
		vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
		-- draw a box by pressing "f" with visual selection
		vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
		print("Venn mode enabled")
	else
		vim.cmd([[setlocal ve=]])
		vim.api.nvim_buf_del_keymap(0, "n", "J")
		vim.api.nvim_buf_del_keymap(0, "n", "K")
		vim.api.nvim_buf_del_keymap(0, "n", "L")
		vim.api.nvim_buf_del_keymap(0, "n", "H")
		vim.api.nvim_buf_del_keymap(0, "v", "f")
		vim.b.venn_enabled = nil
		print("Venn mode disabled")
	end
end

-- Use the official toggle function with our keybinding
vim.keymap.set("n", "<leader>vv", function()
	Toggle_venn()
end, { noremap = true, silent = true, desc = "Toggle Venn ASCII Drawing Mode" })

-- Vim-easy-align keybindings
vim.keymap.set(
	{ "n", "x" },
	"ga",
	"<Plug>(EasyAlign)",
	{ noremap = false, silent = true, desc = "Easy Align" }
)