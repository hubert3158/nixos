-- Smart buffer cleanup module
-- Automatically closes unused buffers to reduce memory usage in long sessions
local M = {}

-- Configuration
M.config = {
	-- How long (in minutes) before a buffer is considered stale
	max_inactive_minutes = 30,
	-- Maximum number of buffers to keep open
	max_buffers = 20,
	-- How often to run cleanup (in minutes)
	cleanup_interval = 10,
	-- Buffer types to never close
	protected_filetypes = {
		"neo-tree",
		"NvimTree",
		"toggleterm",
		"terminal",
		"qf",
		"help",
		"man",
		"fugitive",
		"git",
		"dap-repl",
		"dapui_scopes",
		"dapui_breakpoints",
		"dapui_stacks",
		"dapui_watches",
		"dapui_console",
		"lazygit",
		"TelescopePrompt",
		"trouble",
		"Outline",
		"aerial",
		"dbui",
		"dbout",
	},
	-- Enable notifications when buffers are closed
	notify = false,
}

-- Track buffer access times
local buffer_access = {}

-- Update access time for a buffer
local function update_access_time(bufnr)
	buffer_access[bufnr] = os.time()
end

-- Check if buffer is protected
local function is_protected(bufnr)
	local ft = vim.bo[bufnr].filetype
	for _, protected in ipairs(M.config.protected_filetypes) do
		if ft == protected then
			return true
		end
	end
	return false
end

-- Check if buffer should be kept
local function should_keep_buffer(bufnr)
	-- Must be valid and listed
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	if not vim.bo[bufnr].buflisted then
		return false
	end

	-- Keep modified buffers
	if vim.bo[bufnr].modified then
		return true
	end

	-- Keep current buffer
	if bufnr == vim.api.nvim_get_current_buf() then
		return true
	end

	-- Keep buffers visible in any window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			return true
		end
	end

	-- Keep protected filetypes
	if is_protected(bufnr) then
		return true
	end

	return false
end

-- Get buffer age in minutes
local function get_buffer_age_minutes(bufnr)
	local access_time = buffer_access[bufnr]
	if not access_time then
		return 0 -- Unknown, treat as fresh
	end
	return (os.time() - access_time) / 60
end

-- Close stale buffers
function M.cleanup_stale_buffers()
	local closed = 0
	local buffers = vim.api.nvim_list_bufs()

	for _, bufnr in ipairs(buffers) do
		if not should_keep_buffer(bufnr) then
			local age = get_buffer_age_minutes(bufnr)
			if age > M.config.max_inactive_minutes then
				-- Close buffer without saving
				pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
				buffer_access[bufnr] = nil
				closed = closed + 1
			end
		end
	end

	if closed > 0 and M.config.notify then
		vim.notify(string.format("Closed %d stale buffer(s)", closed), vim.log.levels.INFO)
	end

	return closed
end

-- Close oldest buffers if we exceed max_buffers
function M.cleanup_excess_buffers()
	local buffers = {}

	-- Collect all closeable buffers with their access times
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
			if not should_keep_buffer(bufnr) then
				table.insert(buffers, {
					bufnr = bufnr,
					access_time = buffer_access[bufnr] or os.time(),
				})
			end
		end
	end

	-- Count total listed buffers
	local total_listed = #vim.tbl_filter(function(b)
		return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
	end, vim.api.nvim_list_bufs())

	if total_listed <= M.config.max_buffers then
		return 0
	end

	-- Sort by access time (oldest first)
	table.sort(buffers, function(a, b)
		return a.access_time < b.access_time
	end)

	-- Close oldest buffers
	local to_close = total_listed - M.config.max_buffers
	local closed = 0

	for i = 1, math.min(to_close, #buffers) do
		local bufnr = buffers[i].bufnr
		pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
		buffer_access[bufnr] = nil
		closed = closed + 1
	end

	if closed > 0 and M.config.notify then
		vim.notify(string.format("Closed %d excess buffer(s)", closed), vim.log.levels.INFO)
	end

	return closed
end

-- Run full cleanup
function M.cleanup()
	local stale = M.cleanup_stale_buffers()
	local excess = M.cleanup_excess_buffers()
	return stale + excess
end

-- Get buffer stats
function M.get_stats()
	local total = 0
	local stale = 0
	local protected = 0

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
			total = total + 1
			if is_protected(bufnr) then
				protected = protected + 1
			elseif get_buffer_age_minutes(bufnr) > M.config.max_inactive_minutes then
				stale = stale + 1
			end
		end
	end

	return {
		total = total,
		stale = stale,
		protected = protected,
		max = M.config.max_buffers,
	}
end

-- Setup function
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Track buffer access on BufEnter
	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("BufferCleanupTracking", { clear = true }),
		callback = function(args)
			update_access_time(args.buf)
		end,
	})

	-- Initialize access times for existing buffers
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) then
			buffer_access[bufnr] = os.time()
		end
	end

	-- Set up periodic cleanup timer
	local timer = vim.uv.new_timer()
	timer:start(
		M.config.cleanup_interval * 60 * 1000, -- Initial delay
		M.config.cleanup_interval * 60 * 1000, -- Repeat interval
		vim.schedule_wrap(function()
			M.cleanup()
		end)
	)

	-- User commands
	vim.api.nvim_create_user_command("BufferCleanup", function()
		local closed = M.cleanup()
		vim.notify(string.format("Closed %d buffer(s)", closed), vim.log.levels.INFO)
	end, { desc = "Clean up stale and excess buffers" })

	vim.api.nvim_create_user_command("BufferStats", function()
		local stats = M.get_stats()
		vim.notify(
			string.format(
				"Buffers: %d total, %d stale, %d protected (max: %d)",
				stats.total,
				stats.stale,
				stats.protected,
				stats.max
			),
			vim.log.levels.INFO
		)
	end, { desc = "Show buffer statistics" })
end

return M
