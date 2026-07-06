-- neotest — run/debug tests inline. Loaded via lz.n on its <leader>T* keys
-- (plugin/lazy-load.lua). Adapters are opt plugins, packadd'ed here.
--
-- neotest-java needs a one-time `:NeotestJavaSetup` to fetch its
-- junit-platform-console-standalone jar.

vim.cmd.packadd("neotest-java")
vim.cmd.packadd("neotest-jest")
vim.cmd.packadd("neotest-vitest")

-- Rust adapter ships inside rustaceanvim (opt, normally loads on ft=rust);
-- force-load through lz.n so its config hook still runs exactly once.
require("lz.n").trigger_load("rustaceanvim")

local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-jest")({}),
		require("neotest-vitest")({}),
		require("neotest-java")({}),
		require("rustaceanvim.neotest"),
	},
})

-- ============================================================================
-- Keymaps (<leader>T* — <leader>t* is taken by toggles/ToggleTerm)
-- ============================================================================
local map = vim.keymap.set

map("n", "<leader>Tt", function()
	neotest.run.run()
end, { silent = true, desc = "Test nearest" })
map("n", "<leader>Tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { silent = true, desc = "Test file" })
map("n", "<leader>Ta", function()
	neotest.run.run(vim.fn.getcwd())
end, { silent = true, desc = "Test all (cwd)" })
map("n", "<leader>Td", function()
	neotest.run.run({ strategy = "dap" })
end, { silent = true, desc = "Debug nearest test (DAP)" })
map("n", "<leader>TS", function()
	neotest.run.stop()
end, { silent = true, desc = "Stop test run" })
map("n", "<leader>Ts", function()
	neotest.summary.toggle()
end, { silent = true, desc = "Toggle test summary" })
map("n", "<leader>To", function()
	neotest.output.open({ enter = true })
end, { silent = true, desc = "Open test output" })
map("n", "<leader>TO", function()
	neotest.output_panel.toggle()
end, { silent = true, desc = "Toggle test output panel" })
map("n", "]t", function()
	neotest.jump.next({ status = "failed" })
end, { silent = true, desc = "Next failed test" })
map("n", "[t", function()
	neotest.jump.prev({ status = "failed" })
end, { silent = true, desc = "Previous failed test" })
