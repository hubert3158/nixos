-- which-key v3 — group labels for every <leader> namespace so the popup reads
-- as a menu (Helix space-mode style). The namespace registry and the
-- philosophy behind it live in lua/user/keymaps.lua.
local wk = require("which-key")

wk.setup()

wk.add({
	{ "<leader>a", group = "ai" },
	{ "<leader>b", group = "buffers" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>D", group = "database" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git" },
	{ "<leader>h", group = "harpoon" },
	{ "<leader>m", group = "markdown" },
	{ "<leader>r", group = "run" },
	{ "<leader>s", group = "search/replace" },
	{ "<leader>t", group = "test" },
	{ "<leader>u", group = "toggles" },
	{ "<leader>x", group = "diagnostics" },
})
