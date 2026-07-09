-- Compat shims for APIs whose OLD call forms are deprecated but still used by
-- pinned plugins (checkhealth vim.deprecated). Instead of patching every call
-- site in every plugin (whack-a-mole across noice, diffview, git-conflict,
-- debugprint, ...), translate old-form calls to the new API here — the
-- deprecated core path never executes, so no warning and no breakage when
-- nvim eventually removes it.
--
-- Loaded from init.lua BEFORE any plugin code runs.

-- vim.validate{<table>} → per-key positional vim.validate(name, value, ...)
-- Old form accepted shorthand type strings ('n', 's', ...); new form wants
-- full names — normalize validators before dispatch.
local TYPE_SHORTHAND = {
	t = "table",
	s = "string",
	n = "number",
	b = "boolean",
	f = "function",
	c = "callable",
}

local function expand_validator(v)
	if type(v) == "string" then
		return TYPE_SHORTHAND[v] or v
	end
	if type(v) == "table" then
		local out = {}
		for i, t in ipairs(v) do
			out[i] = type(t) == "string" and (TYPE_SHORTHAND[t] or t) or t
		end
		return out
	end
	return v -- function validator, pass through
end

local orig_validate = vim.validate
---@diagnostic disable-next-line: duplicate-set-field
vim.validate = function(a, ...)
	if type(a) == "table" then
		for name, spec in pairs(a) do
			-- spec = { value, validator, optional_or_message }
			orig_validate(name, spec[1], expand_validator(spec[2]), spec[3])
		end
		return
	end
	return orig_validate(a, ...)
end

-- vim.str_utfindex(s[, index]) (returns utf32, utf16) →
-- vim.str_utfindex(s, encoding, index, strict)
local orig_utfindex = vim.str_utfindex
---@diagnostic disable-next-line: duplicate-set-field
vim.str_utfindex = function(s, encoding, index, strict)
	if encoding == nil or type(encoding) == "number" then
		local idx = encoding
		return orig_utfindex(s, "utf-32", idx), orig_utfindex(s, "utf-16", idx)
	end
	return orig_utfindex(s, encoding, index, strict)
end
