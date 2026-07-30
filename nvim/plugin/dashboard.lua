-- Dashboard — snacks.nvim (replaced dashboard-nvim). Configured eagerly so
-- the start screen renders correctly on first paint.
-- The header image is the wallpaper rendered by chafa.
-- Every snacks module that overlaps the existing stack is explicitly off:
-- notifier (nvim-notify), indent (ibl), scroll (neoscroll), bigfile (user/
-- bigfile), statuscolumn (ufo/signcolumn), input/picker (telescope), etc.

-- ukhaan — a Nepali proverb, drawn fresh on every start screen.
--
-- Reads lib/ukhaan.tsv, the same table the `ukhaan` CLI embeds
-- (modules/home-manager/tools/ukhaan.nix). One file read and a split, not a
-- subprocess: the dashboard paints eagerly, and the perf rule in
-- docs/THEME.md is that nothing forks on the startup path for a decoration.
--
-- The romanised column, not the Devanagari one: this line lands in a monospace
-- grid, where Devanagari's pre-base vowel signs and conjuncts come apart, one
-- codepoint per cell. Devanagari lives on the surfaces that shape proportional
-- text — waybar, hyprlock, notifications, the boot splash.
local function pick_ukhaan()
	local ok, lines = pcall(vim.fn.readfile, vim.fn.expand("~/nixos/lib/ukhaan.tsv"))
	if not ok or type(lines) ~= "table" then
		return { "", "" }
	end
	local rows = {}
	for _, l in ipairs(lines) do
		if l:sub(1, 1) ~= "#" and l ~= "" then
			local _, roman, meaning = l:match("^([^\t]*)\t([^\t]*)\t(.*)$")
			if roman and roman ~= "" then
				rows[#rows + 1] = { roman, meaning or "" }
			end
		end
	end
	if #rows == 0 then
		return { "", "" }
	end
	return rows[math.random(#rows)]
end

math.randomseed(os.time())
local haiku = pick_ukhaan()

require("snacks").setup({
	-- overlap guards — this config uses snacks for dashboard + image only
	bigfile = { enabled = false },
	notifier = { enabled = false },
	quickfile = { enabled = false },
	statuscolumn = { enabled = false },
	scroll = { enabled = false },
	indent = { enabled = false },
	input = { enabled = false },
	scope = { enabled = false },
	words = { enabled = false },
	picker = { enabled = false },
	explorer = { enabled = false },

	-- inline images (kitty graphics protocol; markdown, telescope previews)
	image = { enabled = true },

	dashboard = {
		enabled = true,
		width = 62,
		preset = {
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
				{ icon = " ", key = "g", desc = "Live Grep", action = ":Telescope live_grep" },
				{ icon = " ", key = "n", desc = "New File", action = ":enew" },
				{ icon = " ", key = "c", desc = "Config", action = ":edit $MYVIMRC" },
				{ icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
			},
			-- The old ANSI-Shadow block letters were three times heavier than
			-- anything else on this screen and fought the ink wash below them.
			-- This is the same word in a half-block face — one stroke weight,
			-- ▒ shading in place of a drop shadow, sitting inside its own
			-- margin rule like a print colophon.
			-- Lines are centred by snacks (it measures display width, so the
			-- mark line lands correctly) — no manual padding.
			header = table.concat({
				"──────────────────────────────────────",
				"",
				"░█▀█░█▀▀░█▀█░█░█░▀█▀░█▄█",
				"░█░█░█▀▀░█░█░▀▄▀░░█░░█░█",
				"░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀",
				"",
				"h i m a l  ·  h i m a l a y a",
				"──────────────────────────────────────",
			}, "\n"),
		},
		sections = {
			{ section = "header", padding = 1 },
			{
				-- the actual wallpaper, painted in unicode half-blocks
				section = "terminal",
				cmd = "chafa "
					.. vim.fn.expand("~/nixos/images/walls/great-wave-ink.png")
					.. " --format symbols --symbols vhalf --size 60x14 --stretch; sleep .1",
				height = 14,
				padding = 1,
			},
			{ section = "keys", gap = 1, padding = 1 },
			{ section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
			{
				text = {
					{ haiku[1] .. "\n", hl = "SnacksDashboardFooter" },
					{ haiku[2], hl = "SnacksDashboardFooter" },
				},
				align = "center",
				padding = 1,
			},
			-- NOTE: no { section = "startup" } — it requires lazy.nvim
			-- ('lazy.stats'), which doesn't exist in this nix-packaged setup.
		},
	},
})
