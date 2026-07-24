-- 七十二候 in the editor.
--
-- Reads the `sekki` CLI (modules/home-manager/tools/sekki.nix, data in
-- lib/sekki.nix) so the statusline can quietly name the current five-day
-- microseason — the same one waybar is showing in the bar overhead.
--
-- Deliberately asynchronous: vim.system() spawns off the main loop and the
-- result lands whenever it lands. Nothing about startup waits on it, and
-- until it arrives every consumer just gets an empty string. A synchronous
-- vim.fn.system() here would put a process spawn (~10 ms) on the startup path
-- for a decoration.
--
-- Refreshed every four hours, which is 30× more often than the value can
-- possibly change — cheap insurance for sessions left open across midnight.

local M = {
	---@type table|nil  decoded output of `sekki json`, nil until it arrives
	current = nil,
}

local REFRESH_MS = 4 * 60 * 60 * 1000

local timer = nil

--- Fetch the current microseason in the background.
---@param cb fun(data: table|nil)|nil  called on the main loop once decoded
function M.fetch(cb)
	if vim.fn.executable("sekki") == 0 then
		return
	end

	vim.system({ "sekki", "json" }, { text = true }, function(res)
		if res.code ~= 0 or not res.stdout or res.stdout == "" then
			return
		end
		vim.schedule(function()
			local ok, data = pcall(vim.json.decode, res.stdout)
			if not ok or type(data) ~= "table" or not data.ko then
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

--- Compact statusline segment: "夏 桐始結花". Empty until the first fetch lands.
---@return string
function M.segment()
	local c = M.current
	if not c then
		return ""
	end
	return c.kanji .. " " .. c.ko
end

--- Full one-liner: "大暑 · 桐始結花 — paulownia trees produce seeds".
---@return string
function M.line()
	local c = M.current
	return c and c.line or ""
end

--- Everything, for :Sekki and tooltips.
---@return string
function M.verbose()
	local c = M.current
	if not c then
		return "sekki: not loaded yet"
	end
	return table.concat({
		c.kanji .. "  " .. c.ko .. "   " .. c.romaji,
		c.en,
		"",
		c.sekki .. " " .. c.sekkiRomaji .. " · " .. c.sekkiEn,
		("候 %d / %d"):format(c.index, c.total),
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

	vim.api.nvim_create_user_command("Sekki", function()
		vim.notify(M.verbose(), vim.log.levels.INFO, { title = "七十二候" })
	end, { desc = "Show the current microseason" })
end

return M
