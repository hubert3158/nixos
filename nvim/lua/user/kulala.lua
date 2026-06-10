-- Kulala HTTP client setup + keymaps. Loaded via lz.n on ft=http.
-- Treesitter parser registration for http lives in plugin/treesitter.lua.

require("kulala").setup({
	default_view = "body",
})

local map = vim.keymap.set

map("n", "<leader>ks", function()
	require("kulala").run()
end, { silent = true, desc = "Execute HTTP request under cursor" })

map("n", "<leader>ka", function()
	require("kulala").run_all()
end, { silent = true, desc = "Execute all HTTP requests in file" })

map("n", "<leader>kr", function()
	require("kulala").replay()
end, { silent = true, desc = "Replay last HTTP request" })

map("n", "<leader>kb", function()
	require("kulala.ui").show_body()
end, { silent = true, desc = "Display response body" })

map("n", "<leader>kh", function()
	require("kulala.ui").show_headers()
end, { silent = true, desc = "Display response headers" })

map("n", "<leader>kS", function()
	require("kulala").scratchpad()
end, { silent = true, desc = "Open HTTP request scratchpad" })

map("n", "<leader>ko", function()
	require("kulala").open()
end, { silent = true, desc = "Open request in new buffer" })

map("n", "<leader>kt", function()
	-- Find all Kulala windows
	local kulala_wins = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if string.match(buf_name, "kulala://") then
			table.insert(kulala_wins, win)
		end
	end

	if #kulala_wins > 0 then
		-- Close only the Kulala windows, not the whole tab
		for _, win in ipairs(kulala_wins) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end
	else
		require("kulala.ui").show_body()
	end
end, { silent = true, desc = "Toggle Kulala windows on/off" })

map("n", "<leader>kf", function()
	require("kulala").search()
end, { silent = true, desc = "Search for HTTP endpoints" })

map("n", "<leader>kc", function()
	require("kulala").copy()
end, { silent = true, desc = "Copy HTTP command to clipboard" })

map("n", "<leader>ke", function()
	require("kulala").set_selected_env()
end, { silent = true, desc = "Select HTTP env (mock/sandbox/production)" })
