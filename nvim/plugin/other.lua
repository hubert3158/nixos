-- LUALINE CONFIGURATION
-- Autocommand to refresh lualine when recording macros
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	callback = function()
		require("lualine").refresh()
	end,
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "eldritch",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { { "mode", icon = "" } },
		lualine_b = {
			{ "branch", icon = "" },
			{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
			{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
		},
		lualine_c = { { "filename", path = 1, icon = "󰄔" } },
		lualine_x = {
			{
				function()
					local reg = vim.fn.reg_recording()
					if reg == "" then
						return ""
					end
					return " @" .. reg
				end,
				cond = function()
					return vim.fn.reg_recording() ~= ""
				end,
			},
			{ "encoding", icon = "󰃮" },
			{ "fileformat", symbols = { unix = "", dos = "", mac = "" } },
			{ "filetype", icon_only = true },
		},
		lualine_y = { { "progress", icon = "" } },
		lualine_z = { { "location", icon = "" } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- Comment
require("Comment").setup()

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
]])
