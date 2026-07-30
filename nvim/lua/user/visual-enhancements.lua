-- Statusline + bufferline. Loaded via lz.n on DeferredUIEnter.
-- Dashboard config lives in plugin/dashboard.lua (must be eager for first paint).
--
-- Himal Himal (docs/THEME.md). The statusline is a hand-rolled
-- kanagawa theme rather than lualine's bundled one, for two reasons:
--   · the mode cap is a three-letter tag (NOR INS VIS CMD …), and each mode
--     owns a pigment, so the left end of the bar is a colour you read
--     before you read text;
--   · the segments are the same ink ramp as the waybar islands, so the two
--     bars stacked on one screen read as one surface.
--
-- Every hex below is a lib/palette.nix value — scripts/theme-lint.sh enforces
-- that, and duplicating the literals here (rather than reaching into the
-- kanagawa plugin's internals) keeps this file independent of that plugin's
-- private API.

local M = {}

-- ── palette (Kanagawa Wave) ────────────────────────────────────────────
local P = {
	sumiInk0 = "#16161D",
	sumiInk1 = "#181820",
	sumiInk2 = "#1A1A22",
	sumiInk3 = "#1F1F28",
	sumiInk4 = "#2A2A37",
	sumiInk5 = "#363646",
	sumiInk6 = "#54546D",
	waveBlue1 = "#223249",
	waveBlue2 = "#2D4F67",
	fujiWhite = "#DCD7BA",
	oldWhite = "#C8C093",
	fujiGray = "#727169",
	crystalBlue = "#7E9CD8",
	springBlue = "#7FB4CA",
	oniViolet = "#957FB8",
	springViolet = "#938AA9",
	dragonBlue = "#658594",
	carpYellow = "#E6C384",
	springGreen = "#98BB6C",
	waveAqua = "#7AA89F",
	sakuraPink = "#D27E99",
	surimiOrange = "#FFA066",
	waveRed = "#E46876",
	peachRed = "#FF5D62",
	samuraiRed = "#E82424",
}

-- ── glyphs ─────────────────────────────────────────────────────────────
-- Written as \u{…} escapes rather than pasted characters on purpose: the
-- previous revision of this file had silently lost every one of them to an
-- editor round-trip and had been running with `icon = ""` for the branch, the
-- diff counts, the separators and the REC badge. An escape either compiles or
-- it doesn't. Every codepoint below is present in Maple Mono NF.
local G = {
	sep_left = "\u{E0B6}", -- powerline left half circle
	sep_right = "\u{E0B4}", -- powerline right half circle
	trunc_left = "\u{E0B2}", -- powerline left triangle
	trunc_right = "\u{E0B0}", -- powerline right triangle
	branch = "\u{E0A0}", -- powerline git branch
	added = "\u{F0415}", -- md plus
	modified = "\u{F03EB}", -- md pencil
	removed = "\u{F0374}", -- md minus
	error = "\u{F015A}", -- md close-circle
	warn = "\u{F002A}", -- md alert
	info = "\u{F02FD}", -- md information
	hint = "\u{F0336}", -- md lightbulb
	lsp = "\u{F048B}", -- md server-network
	readonly = "\u{F033E}", -- md lock
	record = "\u{F044A}", -- md record-circle
	location = "\u{F05B}", -- fa crosshairs
	close = "\u{F0156}", -- md close
	tree = "\u{F0E56}", -- md file-tree
}

-- ── mode → cap ─────────────────────────────────────────────────────────
-- Three letters, one cell each, drawn from the terminal's own face. Every
-- cap is the same width so the bar never reflows when the mode changes, and
-- the same set is mirrored by the tmux session pill one layer down
-- (modules/home-manager/programs/tmux.nix).
local MODE_CAP = {
	["NORMAL"] = "NOR",
	["O-PENDING"] = "NOR",
	["INSERT"] = "INS",
	["VISUAL"] = "VIS",
	["V-LINE"] = "V-L",
	["V-BLOCK"] = "V-B",
	["SELECT"] = "SEL",
	["S-LINE"] = "SEL",
	["S-BLOCK"] = "SEL",
	["REPLACE"] = "REP",
	["V-REPLACE"] = "REP",
	["COMMAND"] = "CMD",
	["EX"] = "CMD",
	["TERMINAL"] = "TRM",
	["CONFIRM"] = "CNF",
	["MORE"] = "MOR",
	["SHELL"] = "TRM",
}

-- ── theme ──────────────────────────────────────────────────────────────
-- b/c are shared: only the mode cap changes pigment, so mode changes read as
-- a single dot of colour moving, not as the whole bar repainting.
local b = { fg = P.oldWhite, bg = P.sumiInk4 }
local c = { fg = P.fujiGray, bg = P.sumiInk1 }

local function cap(colour)
	return { a = { fg = P.sumiInk0, bg = colour, gui = "bold" }, b = b, c = c }
end

local theme = {
	normal = cap(P.crystalBlue),
	insert = cap(P.springGreen),
	visual = cap(P.oniViolet),
	replace = cap(P.peachRed),
	command = cap(P.carpYellow),
	terminal = cap(P.waveAqua),
	inactive = {
		a = { fg = P.fujiGray, bg = P.sumiInk1 },
		b = { fg = P.fujiGray, bg = P.sumiInk1 },
		c = { fg = P.fujiGray, bg = P.sumiInk1 },
	},
}

-- ── scroll position as one ink stroke ──────────────────────────────────
local SCROLL = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

local function scroll_mark()
	local cur = vim.fn.line(".")
	local total = vim.fn.line("$")
	if total <= 1 then
		return SCROLL[#SCROLL]
	end
	local i = math.floor((cur - 1) / (total - 1) * (#SCROLL - 1)) + 1
	return SCROLL[i]
end

-- ── attached language servers ──────────────────────────────────────────
local function lsp_names()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end
	local names = {}
	for _, client in ipairs(clients) do
		names[#names + 1] = client.name
	end
	return G.lsp .. " " .. table.concat(names, "·")
end

function M.setup()
	local patro = require("user.patro")
	patro.setup()

	-- Refresh lualine when recording macros so the REC indicator shows up,
	-- and notify loudly — a stuck accidental recording silently disables
	-- blink.cmp and which-key popups (looks like "completion broke").
	vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
		group = vim.api.nvim_create_augroup("LualineMacroRefresh", { clear = true }),
		callback = function(ev)
			require("lualine").refresh()
			if ev.event == "RecordingEnter" then
				vim.notify(
					"Recording macro @"
						.. vim.fn.reg_recording()
						.. " — press q to stop\n(completion is disabled while recording)",
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
			theme = theme,
			globalstatus = true,
			disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
			-- rounded caps on the sections, a thin ink stroke between
			-- components — the same ▏ language as ibl and the window separators
			component_separators = { left = "│", right = "│" },
			section_separators = { left = G.sep_right, right = G.sep_left },
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						return " " .. (MODE_CAP[str] or str) .. " "
					end,
					padding = 0,
				},
			},
			lualine_b = {
				{ "branch", icon = G.branch },
				{
					"diff",
					symbols = {
						added = G.added .. " ",
						modified = G.modified .. " ",
						removed = G.removed .. " ",
					},
					colored = true,
				},
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					symbols = { modified = "●", readonly = G.readonly, unnamed = "[no name]" },
				},
				{ "searchcount", color = { fg = P.carpYellow, gui = "bold" } },
				{ "selectioncount", color = { fg = P.oniViolet } },
			},
			lualine_x = {
				{
					function()
						local reg = vim.fn.reg_recording()
						if reg == "" then
							return ""
						end
						return " " .. G.record .. " REC @" .. reg .. " "
					end,
					cond = function()
						return vim.fn.reg_recording() ~= ""
					end,
					-- kanagawa samuraiRed on paper white — impossible to miss
					color = { bg = P.samuraiRed, fg = P.fujiWhite, gui = "bold" },
				},
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = {
						error = G.error .. " ",
						warn = G.warn .. " ",
						info = G.info .. " ",
						hint = G.hint .. " ",
					},
					colored = true,
				},
				{ lsp_names, color = { fg = P.dragonBlue } },
				{ "filetype", colored = true, icon_only = false },
			},
			lualine_y = {
				-- Bikram Sambat — today's date, quietly, in chrome grey.
				-- Empty (and therefore invisible) until the async fetch lands.
				{
					function()
						return patro.segment()
					end,
					cond = function()
						return patro.current ~= nil
					end,
					color = { fg = P.springViolet, gui = "italic" },
				},
				{ "progress", padding = { left = 1, right = 1 } },
			},
			lualine_z = {
				{
					function()
						return scroll_mark()
					end,
					padding = { left = 1, right = 0 },
				},
				{
					"location",
					fmt = function(str)
						return G.location .. " " .. str
					end,
				},
			},
		},
		extensions = { "neo-tree", "toggleterm", "trouble" },
	})

	-- ── bufferline ────────────────────────────────────────────────────
	if pcall(require, "bufferline") then
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "buffers",
				style_preset = bufferline.style_preset.minimal,
				themable = true,
				-- superscript ordinals: the buffer number rides above the
				-- name instead of stealing a whole column
				numbers = function(opts)
					return opts.raise(opts.ordinal)
				end,
				indicator = { style = "icon", icon = "▎" },
				buffer_close_icon = G.close,
				modified_icon = "●",
				close_icon = G.close,
				left_trunc_marker = G.trunc_left,
				right_trunc_marker = G.trunc_right,
				separator_style = "slant",
				always_show_bufferline = true,
				-- unread problems visible without opening the buffer
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(_, _, diag)
					local parts = {}
					if diag.error then
						parts[#parts + 1] = G.error .. " " .. diag.error
					end
					if diag.warning then
						parts[#parts + 1] = G.warn .. " " .. diag.warning
					end
					return table.concat(parts, " ")
				end,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				offsets = {
					{
						filetype = "neo-tree",
						text = G.tree .. "  file tree",
						text_align = "left",
						separator = true,
						highlight = "Directory",
					},
				},
			},
			highlights = {
				buffer_selected = { bold = true, italic = false },
				numbers_selected = { bold = true, italic = false },
			},
		})
	end
end

return M
