-- User commands

vim.api.nvim_create_user_command("ToggleSmearCursor", function()
	local smear = require("smear_cursor")
	smear.enabled = not smear.enabled
	print("Smear cursor: " .. (smear.enabled and "enabled" or "disabled"))
end, { desc = "Toggle smear cursor animation" })

vim.api.nvim_create_user_command("DisableHeavyFeatures", function()
	require("smear_cursor").enabled = false
	vim.treesitter.stop()
	vim.diagnostic.enable(false)
	print("Heavy features disabled for better performance")
end, { desc = "Disable performance-heavy features" })

vim.api.nvim_create_user_command("EnableHeavyFeatures", function()
	require("smear_cursor").enabled = true
	vim.treesitter.start()
	vim.diagnostic.enable(true)
	print("Heavy features enabled")
end, { desc = "Enable performance-heavy features" })

vim.api.nvim_create_user_command("ProfileStartup", function()
	vim.cmd("!nvim --startuptime /tmp/nvim-startup.log +qa && cat /tmp/nvim-startup.log")
end, { desc = "Profile Neovim startup time" })

vim.api.nvim_create_user_command("CheckPerformance", function()
	local stats = {
		lua_files = vim.fn.system("find " .. vim.fn.stdpath("config") .. " -name '*.lua' | wc -l"),
		buffer_count = #vim.api.nvim_list_bufs(),
		autocmd_count = #vim.api.nvim_get_autocmds({}),
		loaded_modules = 0,
	}

	for _ in pairs(package.loaded) do
		stats.loaded_modules = stats.loaded_modules + 1
	end

	print("=== Neovim Performance Stats ===")
	print("Lua config files: " .. vim.trim(stats.lua_files))
	print("Open buffers: " .. stats.buffer_count)
	print("Autocmds: " .. stats.autocmd_count)
	print("Loaded Lua modules: " .. stats.loaded_modules)
	print("Update time: " .. vim.o.updatetime .. "ms")
	print("Timeout length: " .. vim.o.timeoutlen .. "ms")
end, { desc = "Check Neovim performance stats" })
