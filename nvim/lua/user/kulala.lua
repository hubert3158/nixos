-- Kulala HTTP client setup + keymaps. Loaded via lz.n on ft=http.
-- Treesitter parser registration for http lives in plugin/treesitter.lua.
--
-- Keymaps are buffer-local on localleader (,) — HTTP-only actions stay out of
-- the global <leader> namespace (philosophy: user/keymaps.lua). This module
-- loads when the FIRST http buffer's FileType event fires, which is already
-- past — so existing http buffers get mapped explicitly below, and the
-- autocmd covers every buffer after that.

require("kulala").setup({
	default_view = "body",
})

local function http_keymaps(buf)
	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
	end

	map("<localleader>s", function()
		require("kulala").run()
	end, "Send request under cursor")
	map("<localleader>a", function()
		require("kulala").run_all()
	end, "Send all requests in file")
	map("<localleader>r", function()
		require("kulala").replay()
	end, "Replay last request")
	map("<localleader>b", function()
		require("kulala.ui").show_body()
	end, "Show response body")
	map("<localleader>h", function()
		require("kulala.ui").show_headers()
	end, "Show response headers")
	map("<localleader>S", function()
		require("kulala").scratchpad()
	end, "Open scratchpad")
	map("<localleader>o", function()
		require("kulala").open()
	end, "Open request in new buffer")
	map("<localleader>f", function()
		require("kulala").search()
	end, "Find endpoints")
	map("<localleader>c", function()
		require("kulala").copy()
	end, "Copy as curl command")
	map("<localleader>e", function()
		require("kulala").set_selected_env()
	end, "Select environment")
	map("<localleader>t", function()
		-- Find all Kulala windows
		local kulala_wins = {}
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local wbuf = vim.api.nvim_win_get_buf(win)
			local buf_name = vim.api.nvim_buf_get_name(wbuf)
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
	end, "Toggle kulala windows")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	group = vim.api.nvim_create_augroup("kulala_keymaps", { clear = true }),
	callback = function(args)
		http_keymaps(args.buf)
	end,
})

-- The http buffer that triggered this load already missed the autocmd
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "http" then
		http_keymaps(buf)
	end
end
