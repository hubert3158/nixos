-- Harpoon — <leader>h group + <leader>1..4 direct select
-- (namespace registry: user/keymaps.lua; lz.n key triggers: plugin/lazy-load.lua)

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

local map = vim.keymap.set

map("n", "<leader>ha", function()
	harpoon:list():add()
end, { silent = true, desc = "Add file" })
map("n", "<leader>hh", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { silent = true, desc = "Quick menu" })
map("n", "<leader>hp", function()
	harpoon:list():prev()
end, { silent = true, desc = "Previous file" })
map("n", "<leader>hn", function()
	harpoon:list():next()
end, { silent = true, desc = "Next file" })

for i = 1, 4 do
	map("n", "<leader>" .. i, function()
		harpoon:list():select(i)
	end, { silent = true, desc = "Harpoon file " .. i })
end
