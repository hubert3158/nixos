-- Statusline + bufferline configuration. Loaded via lz.n on DeferredUIEnter.
-- Dashboard config lives in plugin/dashboard.lua (must be eager for first paint).

local M = {}

function M.setup()
	-- Refresh lualine when recording macros so the REC indicator shows up,
	-- and notify loudly — a stuck accidental recording silently disables
	-- blink.cmp and which-key popups (looks like "completion broke").
	vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
		group = vim.api.nvim_create_augroup("LualineMacroRefresh", { clear = true }),
		callback = function(ev)
			require("lualine").refresh()
			if ev.event == "RecordingEnter" then
				vim.notify(
					"Recording macro @" .. vim.fn.reg_recording() .. " — press q to stop\n(completion is disabled while recording)",
					vim.log.levels.WARN,
					{ title = "Macro" }
				)
			else
				vim.notify("Macro recording stopped", vim.log.levels.INFO, { title = "Macro" })
			end
		end,
	})

	require("lualine").setup({
		options = {
			-- kanagawa.nvim ships a lualine theme that follows the active variant
			theme = "kanagawa",
			globalstatus = true,
			disabled_filetypes = { statusline = { "dashboard" } },
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
						return "  REC @" .. reg .. " "
					end,
					cond = function()
						return vim.fn.reg_recording() ~= ""
					end,
					-- kanagawa samuraiRed on light fg — impossible to miss
					color = { bg = "#E82424", fg = "#DCD7BA", gui = "bold" },
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
		extensions = { "neo-tree", "toggleterm", "trouble" },
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
						filetype = "neo-tree",
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
