-- Smear Cursor Configuration
-- Smooth cursor animation with command mode and search conflict prevention

require("smear_cursor").setup({
	-- Disable in command mode to prevent glitches with search highlighting
	hide_target_hack = true,
	-- Reduce animation intensity
	smear_between_buffers = false,
	smear_between_neighbor_lines = true,
	-- Disable for specific modes to avoid command line conflicts
	legacy_computing_symbols_support = false,
	-- Add a small delay to reduce conflicts
	time_interval = 20,
	-- Disable animation when in command mode or when search is active
	normal_bg = nil,
	distance_stop_animating = 0.1,
})

-- Disable smear cursor during search operations
local group = vim.api.nvim_create_augroup("SmearCursorDisable", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = group,
	pattern = "*",
	callback = function()
		require("smear_cursor").enabled = false
	end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = group,
	pattern = "*",
	callback = function()
		require("smear_cursor").enabled = true
	end,
})