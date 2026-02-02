-- Disable automatic Treesitter parser installation for kulala.nvim
-- This replaces the internal set_kulala_parser function with a no-op

local ok, config = pcall(require, "kulala.config")
if not ok then
  return
end

local i = 1
while true do
  local name = debug.getupvalue(config.setup, i)
  if not name then
    break
  end
  if name == "set_kulala_parser" then
    debug.setupvalue(config.setup, i, function() end)
    break
  end
  i = i + 1
end
