-- Professional Visual Enhancements Module

local M = {}

-- Setup function to initialize all visual enhancements
function M.setup()
	-- Enhanced lualine configuration
	if pcall(require, "lualine") then
		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							local mode_map = {
								["NORMAL"] = "N",
								["INSERT"] = "I",
								["VISUAL"] = "V",
								["V-LINE"] = "VL",
								["V-BLOCK"] = "VB",
								["COMMAND"] = "C",
								["REPLACE"] = "R",
							}
							return " " .. (mode_map[str] or str)
						end,
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
						colored = true,
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
					},
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
						colored = true,
					},
					{ "encoding", show_bomb = true },
					{ "fileformat", icons_enabled = true },
					{ "filetype", colored = true, icon_only = false },
				},
				lualine_y = {
					{
						"progress",
						fmt = function(str)
							return str .. " "
						end,
					},
				},
				lualine_z = {
					{
						"location",
						fmt = function(str)
							return " " .. str
						end,
					},
				},
			},
			extensions = { "nvim-tree", "toggleterm", "trouble" },
		})
	end

	-- Enhanced dashboard configuration
	if pcall(require, "dashboard") then
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					"                                                       ",
					"                                                       ",
					"                                                       ",
					" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
					" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
					" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
					" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
					" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
					" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
					"                                                       ",
					"                  Professional Setup                  ",
					"                                                       ",
				},
				center = {
					{
						icon = " ",
						desc = "Find File                            ",
						key = "f",
						action = "Telescope find_files",
					},
					{
						icon = " ",
						desc = "Recent Files                        ",
						key = "r",
						action = "Telescope oldfiles",
					},
					{
						icon = " ",
						desc = "Live Grep                           ",
						key = "g",
						action = "Telescope live_grep",
					},
					{
						icon = " ",
						desc = "New File                            ",
						key = "n",
						action = "enew",
					},
					{
						icon = " ",
						desc = "Config                              ",
						key = "c",
						action = "edit $MYVIMRC",
					},
					{
						icon = " ",
						desc = "Quit                                ",
						key = "q",
						action = "quit",
					},
				},
				footer = {
					"",
					"🚀 Ready to code!",
				},
			},
		})
	end

	-- Enhanced bufferline configuration
	if pcall(require, "bufferline") then
		require("bufferline").setup({
			options = {
				mode = "buffers",
				style_preset = require("bufferline").style_preset.minimal,
				themable = true,
				numbers = "none",
				indicator = { style = "icon", icon = "▎" },
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				separator_style = "slant",
				always_show_bufferline = true,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},
			},
			highlights = {
				buffer_selected = {
					bold = true,
					italic = false,
				},
			},
		})
	end
end

return M
