-- Mode ink — the cursor line wears the mode's pigment.
--
-- The statusline mode cap (user/visual-enhancements.lua) is the one dot of
-- colour that moves when the mode changes. This puts a second dot where the
-- eye actually is: the cursor-line number takes the same pigment as the cap,
-- and in insert / replace the line itself takes a faint wash — winterGreen
-- while ink is going down, winterRed while it's being overwritten. Normal mode
-- is left exactly as the kanagawa overrides in init.lua draw it (gold number,
-- plain ink line), so resting looks like it always has.
--
-- Cost: one ModeChanged autocmd; highlights are only rewritten when the mode
-- *family* changes (i→i-completion doesn't count), two nvim_set_hl calls.
-- Hexes are lib/palette.nix values (scripts/theme-lint.sh checks this file).

local M = {}

local P = {
	springGreen = "#98BB6C",
	oniViolet = "#957FB8",
	peachRed = "#FF5D62",
	waveAqua = "#7AA89F",
	winterGreen = "#2B3328",
	winterRed = "#43242B",
}

-- mode family → { number fg, line bg (nil = the colorscheme's own) }
local INK = {
	insert = { nr = P.springGreen, line = P.winterGreen },
	visual = { nr = P.oniViolet },
	replace = { nr = P.peachRed, line = P.winterRed },
	terminal = { nr = P.waveAqua },
}

local function family(mode)
	local c = mode:sub(1, 1)
	if c == "i" then
		return "insert"
	elseif c == "v" or c == "V" or c == "\22" or c == "s" or c == "S" or c == "\19" then
		return "visual"
	elseif c == "R" then
		return "replace"
	elseif c == "t" then
		return "terminal"
	elseif c == "c" or c == "r" or c == "!" then
		return nil -- cmdline / prompts: the cursor isn't in the buffer, keep what's there
	end
	return "normal"
end

local base = {} -- the colorscheme's own CursorLine / CursorLineNr
local current

local function capture()
	base.line = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
	base.nr = vim.api.nvim_get_hl(0, { name = "CursorLineNr", link = false })
	current = nil
end

local function paint(fam)
	if fam == nil or fam == current then
		return
	end
	current = fam
	local ink = INK[fam]
	if not ink then
		vim.api.nvim_set_hl(0, "CursorLine", base.line)
		vim.api.nvim_set_hl(0, "CursorLineNr", base.nr)
		return
	end
	vim.api.nvim_set_hl(0, "CursorLineNr", vim.tbl_extend("force", base.nr, { fg = ink.nr, bold = true }))
	vim.api.nvim_set_hl(0, "CursorLine", ink.line and vim.tbl_extend("force", base.line, { bg = ink.line }) or base.line)
end

function M.setup()
	capture()
	local group = vim.api.nvim_create_augroup("UserModeInk", { clear = true })
	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		callback = function()
			paint(family(vim.v.event.new_mode or vim.api.nvim_get_mode().mode))
		end,
	})
	-- a colorscheme reload rewrites the base groups; re-read them
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = capture,
	})
end

return M
