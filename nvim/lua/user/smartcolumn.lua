-- smartcolumn owns 'colorcolumn' (do not set it statically in options.lua):
-- shows the guides only when a line actually exceeds them.
require("smartcolumn").setup({
	colorcolumn = { "80", "120" },
})
