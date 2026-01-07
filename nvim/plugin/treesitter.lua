-- Filetype detection for .http files
vim.filetype.add({
	extension = {
		http = "http",
	},
})

-- Initialize Kulala
require("kulala").setup({
	default_view = "body",
})
