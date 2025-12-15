-- Debug spectre loading
local ok, spectre = pcall(require, "spectre")

if not ok then
	vim.notify("Failed to load spectre: " .. tostring(spectre), vim.log.levels.ERROR)
	return
end

if not spectre then
	vim.notify("Spectre plugin returned nil!", vim.log.levels.ERROR)
	return
end

-- Print available functions for debugging
vim.notify("Spectre loaded successfully!", vim.log.levels.INFO)

-- Check if required functions exist
local required_functions = { "run_replace", "run_current_replace", "toggle", "open_visual" }
for _, func_name in ipairs(required_functions) do
	if type(spectre[func_name]) ~= "function" then
		vim.notify("Missing function: spectre." .. func_name, vim.log.levels.WARN)
	end
end

-- Minimal setup first
spectre.setup({})

-- Safe key mappings that check if functions exist before calling
local function safe_spectre_call(func_name, ...)
	if type(spectre[func_name]) ~= "function" then
		vim.notify("Function spectre." .. func_name .. " does not exist", vim.log.levels.ERROR)
		return
	end

	local ok, result = pcall(spectre[func_name], ...)
	if not ok then
		vim.notify("Spectre error in " .. func_name .. ": " .. result, vim.log.levels.ERROR)
	end
end

-- Key mappings with safety checks
vim.keymap.set("n", "<leader>S", function()
	safe_spectre_call("toggle")
end, {
	desc = "Toggle Spectre",
})

vim.keymap.set("n", "<leader>sw", function()
	safe_spectre_call("open_visual", { select_word = true })
end, {
	desc = "Search current word",
})

vim.keymap.set("v", "<leader>sw", function()
	vim.cmd("esc")
	safe_spectre_call("open_visual")
end, {
	desc = "Search current word (visual)",
})

vim.keymap.set("n", "<leader>sp", function()
	safe_spectre_call("open_file_search", { select_word = true })
end, {
	desc = "Search on current file",
})

-- Add separate mappings that only work within spectre buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "spectre_panel",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()

		-- Only set these mappings in spectre buffers
		vim.keymap.set("n", "<leader>rc", function()
			safe_spectre_call("run_current_replace")
		end, { buffer = buf, desc = "Replace current line" })

		vim.keymap.set("n", "<leader>R", function()
			safe_spectre_call("run_replace")
		end, { buffer = buf, desc = "Replace all" })

		vim.keymap.set("n", "<leader>q", function()
			safe_spectre_call("send_to_qf")
		end, { buffer = buf, desc = "Send to quickfix" })
	end,
})
