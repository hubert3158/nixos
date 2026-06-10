-- Statusline + bufferline configuration. Loaded via lz.n on DeferredUIEnter.
-- Dashboard config lives in plugin/dashboard.lua (must be eager for first paint).

local M = {}

function M.setup()
	-- Refresh lualine when recording macros so the @reg indicator shows up
	vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
		group = vim.api.nvim_create_augroup("LualineMacroRefresh", { clear = true }),
		callback = function()
			require("lualine").refresh()
		end,
	})

	require("lualine").setup({
		options = {
			-- nixpkgs' catppuccin ships lualine themes as catppuccin-<flavour>.lua
			-- (no plain "catppuccin" module) — name the flavour explicitly.
			theme = "catppuccin-mocha",
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
