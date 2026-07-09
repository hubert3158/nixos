-- Comment.nvim breaks on nvim 0.12 for any buffer whose filetype has no
-- treesitter grammar (sql, extensionless files, ...): every gcc shows the
-- cryptic "[Comment.nvim] nil" warning and nothing gets commented.
--
-- Why: vim.treesitter.get_parser() now returns nil instead of erroring when
-- no parser exists, so ft.calculate()'s `pcall` succeeds with parser = nil
-- and ft.contains(nil):lang() crashes ("attempt to index local 'tree'").
-- The error handler in Comment/utils.lua then prints err.msg of a plain
-- string error — literally "nil". Upstream is unmaintained (pinned
-- 2024-06-09), so patch the resolver here: fall back to the filetype table /
-- &commentstring when there is no parser.
--
-- NOTE: Comment.ft attaches a __newindex metatable that turns assignments
-- into language registrations — rawset is required to replace the function.

local ft = require("Comment.ft")
local ts_calculate = ft.calculate

rawset(ft, "calculate", function(ctx)
	local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
	if not ok or parser == nil then
		return ft.get(vim.bo.filetype, ctx.ctype)
	end
	return ts_calculate(ctx)
end)
