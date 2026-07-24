-- render-markdown — Ink & Wave document rendering (docs/THEME.md).
--
-- COLORS ARE NOT SET HERE. The plugin's defaults link heading backgrounds to
-- the Diff* groups (H1Bg=DiffText, H2Bg=DiffAdd, H3Bg=DiffChange,
-- H4Bg=DiffDelete), which under kanagawa paints the heading hierarchy in the
-- winter diff washes — a document ends up looking like a merge conflict.
-- RenderMarkdown* groups are redefined as a descending ink ramp in init.lua,
-- alongside every other colorscheme override. The plugin links its groups with
-- `default = true`, so the init.lua definitions win.
--
-- This file owns SHAPE only: glyphs, widths, padding.
require("render-markdown").setup({
	-- html: drop raw HTML decorations inside .md (kbd, details, sub, sup).
	-- Avoids the "html parser not installed" warning. Plain markdown still
	-- renders via the markdown/markdown_inline parsers.
	html = { enabled = false },
	-- latex: not using math; disables the utftex/latex2text dependency check.
	latex = { enabled = false },

	heading = {
		-- CJK numerals, same language as the waybar workspace pills
		-- (docs/THEME.md typography). Double-width by design — the icon column
		-- reads as a carved stamp rather than a bullet.
		icons = { "一 ", "二 ", "三 ", "四 ", "五 ", "六 " },
		-- bar hugs the heading text instead of bleeding to the window edge
		width = "block",
		right_pad = 2,
		min_width = 24,
		-- signcolumn is already spoken for (gitsigns + diagnostics, yes:2);
		-- the ink bar is marker enough
		sign = false,
	},

	code = {
		-- recessed block, matching border above/below — a sunken ink slab
		width = "block",
		right_pad = 2,
		min_width = 40,
		border = "thin",
		language_pad = 1,
		sign = false,
	},

	-- ▏ everywhere: same stroke as fillchars vert, ibl guides, indentscope
	quote = { icon = "▏" },
	bullet = { icons = { "◆", "◇", "▪", "▫" } },
	dash = { icon = "─" },

	pipe_table = { preset = "round" },
})
