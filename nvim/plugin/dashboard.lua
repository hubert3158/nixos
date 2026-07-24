-- Dashboard — snacks.nvim (replaced dashboard-nvim). Configured eagerly so
-- the start screen renders correctly on first paint.
-- The wave header is the actual great-wave-ink wallpaper rendered by chafa.
-- Every snacks module that overlaps the existing stack is explicitly off:
-- notifier (nvim-notify), indent (ibl), scroll (neoscroll), bigfile (user/
-- bigfile), statuscolumn (ufo/signcolumn), input/picker (telescope), etc.

local haikus = {
	{ "古池や 蛙飛び込む コードの音", "the old pond — a frog leaps in — the sound of code" },
	{ "波に乗れ バグも流れて 春の海", "ride the wave — even bugs drift away — spring sea" },
	{ "月光や コンパイル待つ 静けさよ", "moonlight — the stillness of waiting for the compile" },
	{ "初雪や コミット一つ 澄みわたる", "first snow — a single commit, perfectly clean" },
	{ "秋深し 隣は何を デプロイする", "deep autumn — what is my neighbour deploying?" },
	{ "夏草や 兵どもが 夢の跡", "summer grass — all that remains of a rewrite" },
	{ "静けさや 岩にしみ入る ログの声", "such stillness — the log seeps into the rock" },
	{ "行く春や 消したブランチ 帰らざる", "spring departs — the deleted branch never returns" },
	{ "灯を消して なほ残りたる 型の error", "lights out — and still the type error remains" },
	{ "朝もやに 立ち上がる server 一つ", "in the morning mist — a single server rises" },
}
math.randomseed(os.time())
local haiku = haikus[math.random(#haikus)]

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
			-- double-width kanji line lands correctly) — no manual padding.
			header = table.concat({
				"──────────────────────────────────────",
				"",
				"░█▀█░█▀▀░█▀█░█░█░▀█▀░█▄█",
				"░█░█░█▀▀░█░█░▀▄▀░░█░░█░█",
				"░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀",
				"",
				"墨 と 波  ·  i n k   a n d   w a v e",
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
