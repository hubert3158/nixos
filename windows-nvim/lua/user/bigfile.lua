-- Large file mode
-- Automatically disables heavy features for large files to prevent freezing
local M = {}

M.config = {
	-- File size threshold in bytes (default: 1MB)
	size_threshold = 1024 * 1024,
	-- Line count threshold (if file has more lines than this)
	line_threshold = 10000,
	-- Pattern for files to always treat as large (e.g., minified files)
	patterns = {
		"%.min%.js$",
		"%.min%.css$",
		"%-lock%.json$",
		"%.lock$",
	},
	-- Features to disable for large files
	features = {
		treesitter = true,
		lsp = true,
		illuminate = true,
		indent_blankline = true,
		colorizer = true,
		matchparen = true,
		syntax = true, -- Falls back to no highlighting if treesitter disabled
		foldmethod = true,
		swapfile = true,
	},
	-- Notify when entering large file mode
	notify = true,
}

-- Track which buffers are in large file mode
local large_file_buffers = {}

-- Check if file matches any large file pattern
local function matches_pattern(filename)
	for _, pattern in ipairs(M.config.patterns) do
		if filename:match(pattern) then
			return true
		end
	end
	return false
end

-- Check if buffer is a large file
local function is_large_file(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)

	-- Check patterns first (fast)
	if matches_pattern(filename) then
		return true, "pattern match"
	end

	-- Check file size
	local ok, stats = pcall(vim.uv.fs_stat, filename)
	if ok and stats then
		if stats.size > M.config.size_threshold then
			return true, string.format("size: %dMB", math.floor(stats.size / 1024 / 1024))
		end
	end

	-- Check line count (for files already loaded)
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	if line_count > M.config.line_threshold then
		return true, string.format("lines: %d", line_count)
	end

	return false, nil
end

-- Disable features for a buffer
local function disable_features(bufnr)
	local features = M.config.features

	-- Disable treesitter
	if features.treesitter then
		pcall(function()
			vim.treesitter.stop(bufnr)
		end)
	end

	-- Disable LSP for this buffer
	if features.lsp then
		pcall(function()
			vim.defer_fn(function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, client in ipairs(clients) do
					vim.lsp.buf_detach_client(bufnr, client.id)
				end
			end, 100)
		end)
	end

	-- Disable vim-illuminate
	if features.illuminate then
		pcall(function()
			require("illuminate").pause_buf()
		end)
	end

	-- Disable indent-blankline
	if features.indent_blankline then
		pcall(function()
			vim.b[bufnr].indent_blankline_enabled = false
			vim.cmd("IBLDisable")
		end)
	end

	-- Disable colorizer
	if features.colorizer then
		pcall(function()
			vim.cmd("ColorizerDetachFromBuffer")
		end)
	end

	-- Buffer-local options
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].undolevels = 100 -- Limit undo history

	-- Window-local options (apply to current window)
	vim.wo.foldmethod = "manual"
	vim.wo.foldenable = false
	vim.wo.relativenumber = false
	vim.wo.cursorline = false
	vim.wo.signcolumn = "no"

	-- Disable matchparen
	if features.matchparen then
		vim.cmd("NoMatchParen")
	end

	-- Disable syntax if treesitter was also disabled
	if features.syntax and features.treesitter then
		vim.bo[bufnr].syntax = ""
	end
end

-- Re-enable features for a buffer
local function enable_features(bufnr)
	local features = M.config.features

	-- Re-enable treesitter
	if features.treesitter then
		pcall(function()
			vim.treesitter.start(bufnr)
		end)
	end

	-- Re-enable LSP
	if features.lsp then
		pcall(function()
			vim.cmd("LspStart")
		end)
	end

	-- Re-enable vim-illuminate
	if features.illuminate then
		pcall(function()
			require("illuminate").resume_buf()
		end)
	end

	-- Re-enable indent-blankline
	if features.indent_blankline then
		pcall(function()
			vim.b[bufnr].indent_blankline_enabled = true
			vim.cmd("IBLEnable")
		end)
	end

	-- Re-enable colorizer
	if features.colorizer then
		pcall(function()
			vim.cmd("ColorizerAttachToBuffer")
		end)
	end

	-- Restore buffer options
	vim.bo[bufnr].swapfile = true
	vim.bo[bufnr].undolevels = 1000

	-- Restore window options
	vim.wo.foldmethod = "expr"
	vim.wo.foldenable = true
	vim.wo.relativenumber = true
	vim.wo.cursorline = true
	vim.wo.signcolumn = "yes"

	-- Re-enable matchparen
	if features.matchparen then
		vim.cmd("DoMatchParen")
	end

	-- Re-enable syntax
	if features.syntax then
		vim.cmd("syntax enable")
	end

	large_file_buffers[bufnr] = nil
end

-- Check and handle a buffer
function M.check_buffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local is_large, reason = is_large_file(bufnr)
	if is_large and not large_file_buffers[bufnr] then
		large_file_buffers[bufnr] = true
		disable_features(bufnr)

		if M.config.notify then
			local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
			vim.notify(
				string.format("Large file mode: %s (%s)", filename, reason),
				vim.log.levels.WARN,
				{ title = "BigFile" }
			)
		end
	end
end

-- Check if buffer is in large file mode
function M.is_large_file_mode(bufnr)
	return large_file_buffers[bufnr or vim.api.nvim_get_current_buf()] or false
end

-- Setup function
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Check files on open
	vim.api.nvim_create_autocmd({ "BufReadPre" }, {
		group = vim.api.nvim_create_augroup("BigFile", { clear = true }),
		callback = function(args)
			-- Defer to let file load first
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(args.buf) then
					M.check_buffer(args.buf)
				end
			end, 0)
		end,
	})

	-- Clean up when buffer is deleted
	vim.api.nvim_create_autocmd("BufDelete", {
		group = vim.api.nvim_create_augroup("BigFileCleanup", { clear = true }),
		callback = function(args)
			large_file_buffers[args.buf] = nil
		end,
	})

	-- User commands
	vim.api.nvim_create_user_command("BigFileEnable", function()
		local bufnr = vim.api.nvim_get_current_buf()
		large_file_buffers[bufnr] = true
		disable_features(bufnr)
		vim.notify("Large file mode enabled", vim.log.levels.INFO)
	end, { desc = "Enable large file mode for current buffer" })

	vim.api.nvim_create_user_command("BigFileDisable", function()
		local bufnr = vim.api.nvim_get_current_buf()
		enable_features(bufnr)
		vim.notify("Large file mode disabled", vim.log.levels.INFO)
	end, { desc = "Disable large file mode for current buffer" })

	vim.api.nvim_create_user_command("BigFileStatus", function()
		local bufnr = vim.api.nvim_get_current_buf()
		local status = large_file_buffers[bufnr] and "enabled" or "disabled"
		local is_large, reason = is_large_file(bufnr)
		local detection = is_large and string.format("detected (%s)", reason) or "not detected"
		vim.notify(
			string.format("Large file mode: %s | Detection: %s", status, detection),
			vim.log.levels.INFO
		)
	end, { desc = "Show large file mode status" })
end

return M
