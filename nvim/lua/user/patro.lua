-- Bikram Sambat in the editor.
--
-- Reads the `patro` CLI (modules/home-manager/tools/patro.nix, data in
-- lib/patro.nix) so the statusline can quietly carry today's Bikram Sambat
-- date — the same one waybar is showing in the bar overhead.
--
-- The statusline segment uses `term`: Nepali month name, Latin digits.
-- Devanagari numerals ink 2-4px shorter than Maple Mono's at the same size
-- and kitty cannot scale a fallback font, so the grid keeps one script and
-- stays optically uniform. `:Patro` prints the romanised long form for the
-- same reason — vim.notify draws into that same grid.
--
-- Deliberately asynchronous: vim.system() spawns off the main loop and the
-- result lands whenever it lands. Nothing about startup waits on it, and
-- until it arrives every consumer just gets an empty string. A synchronous
-- vim.fn.system() here would put a process spawn (~10 ms) on the startup path
-- for a decoration.
--
-- Refreshed every four hours, which is 6× more often than the value can
-- possibly change — cheap insurance for sessions left open across midnight.

local M = {
	---@type table|nil  decoded output of `patro json`, nil until it arrives
	current = nil,
}

local REFRESH_MS = 4 * 60 * 60 * 1000

local timer = nil

--- Fetch today's Bikram Sambat date in the background.
---@param cb fun(data: table|nil)|nil  called on the main loop once decoded
function M.fetch(cb)
	if vim.fn.executable("patro") == 0 then
		return
	end

	vim.system({ "patro", "json" }, { text = true }, function(res)
		if res.code ~= 0 or not res.stdout or res.stdout == "" then
			return
		end
		vim.schedule(function()
			local ok, data = pcall(vim.json.decode, res.stdout)
			if not ok or type(data) ~= "table" or not data.term then
				return
			end
			M.current = data
			-- the statusline is the main consumer; nudge it so the segment
			-- appears without waiting for the next redraw tick
			pcall(function()
				require("lualine").refresh()
			end)
			if cb then
				cb(data)
			end
		end)
	end)
end

--- Compact statusline segment: "Saun 14". Empty until the first fetch lands.
---@return string
function M.segment()
	local c = M.current
	if not c then
		return ""
	end
	return c.term
end

--- Full one-liner: "Saun 14, 2083 · barsha — monsoon".
---@return string
function M.line()
	local c = M.current
	return c and c.line or ""
end

--- Everything, for :Patro and tooltips.
---@return string
function M.verbose()
	local c = M.current
	if not c then
		return "patro: not loaded yet"
	end
	-- Romanised throughout: vim.notify renders in the terminal grid, where
	-- Devanagari words come apart (see modules/home-manager/tools/patro.nix).
	return table.concat({
		c.dateRoman,
		("BS %d-%02d-%02d"):format(c.year, c.month, c.day),
		"",
		c.season .. " ritu · " .. c.en,
	}, "\n")
end

function M.setup()
	M.fetch()

	if timer then
		timer:stop()
	end
	timer = vim.uv.new_timer()
	if timer then
		timer:start(REFRESH_MS, REFRESH_MS, function()
			M.fetch()
		end)
	end

	vim.api.nvim_create_user_command("Patro", function()
		vim.notify(M.verbose(), vim.log.levels.INFO, { title = "Bikram Sambat" })
	end, { desc = "Show today's Bikram Sambat date" })
end

return M
