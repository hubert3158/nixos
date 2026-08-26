require("toggleterm").setup({
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

-- Window nav out of a terminal buffer. Inside a Herdr pane herdr-splits is
-- packadd'ed (see nvim/lua/user/herdr-splits.lua) and owns these chords so they
-- also cross the Herdr pane boundary; everywhere else it isn't on the
-- runtimepath at all and require() fails, so we fall back to a bare wincmd.
local function nav(direction, wincmd)
  return function()
    local ok, herdr_splits = pcall(require, 'herdr-splits')
    if ok then
      herdr_splits['move_cursor_' .. direction]()
    else
      vim.cmd.wincmd(wincmd)
    end
  end
end

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', nav('left', 'h'), opts)
  vim.keymap.set('t', '<C-j>', nav('down', 'j'), opts)
  vim.keymap.set('t', '<C-k>', nav('up', 'k'), opts)
  vim.keymap.set('t', '<C-l>', nav('right', 'l'), opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')