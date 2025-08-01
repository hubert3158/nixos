-- Simple testing setup using existing vim-test functionality
-- Since neotest had build issues, we'll use a simpler approach

-- Key mappings for running tests using built-in terminal
vim.keymap.set("n", "<leader>tt", ":w | !npm test<CR>", { desc = "Run npm tests" })
vim.keymap.set("n", "<leader>tp", ":w | !python -m pytest %<CR>", { desc = "Run current Python test file" })
vim.keymap.set("n", "<leader>tj", ":w | !jest %<CR>", { desc = "Run current Jest test file" })
vim.keymap.set("n", "<leader>tc", ":w | !cargo test<CR>", { desc = "Run Rust tests" })
vim.keymap.set("n", "<leader>tg", ":w | !go test ./...<CR>", { desc = "Run Go tests" })

-- Open test results in quickfix
vim.keymap.set("n", "<leader>tq", ":copen<CR>", { desc = "Open test quickfix" })

-- Simple test file creation helpers
vim.keymap.set("n", "<leader>tf", function()
	local current_file = vim.fn.expand("%:p")
	local test_file = ""
	
	-- JavaScript/TypeScript
	if current_file:match("%.js$") or current_file:match("%.ts$") then
		test_file = current_file:gsub("%.js$", ".test.js"):gsub("%.ts$", ".test.ts")
	-- Python
	elseif current_file:match("%.py$") then
		test_file = current_file:gsub("%.py$", "_test.py")
	-- Rust
	elseif current_file:match("%.rs$") then
		print("Rust tests are typically in the same file or in tests/ directory")
		return
	end
	
	if test_file ~= "" then
		vim.cmd("edit " .. test_file)
	end
end, { desc = "Create/open test file" })

-- Watch mode for continuous testing (requires external tools)
vim.keymap.set("n", "<leader>tw", function()
	local filetype = vim.bo.filetype
	if filetype == "javascript" or filetype == "typescript" then
		vim.cmd("!npm test -- --watch &")
	elseif filetype == "python" then
		vim.cmd("!pytest-watch &")
	else
		print("Watch mode not configured for " .. filetype)
	end
end, { desc = "Start test watch mode" })