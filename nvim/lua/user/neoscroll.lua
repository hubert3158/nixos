require('neoscroll').setup({
  mappings = { '<C-u>', '<C-d>' },
  hide_cursor = true,
  stop_eof = true,
  respect_scrolloff = false,
  cursor_scrolls_alone = true,
  duration_multiplier = 1.0,
  easing = 'linear',
  pre_hook = nil,
  post_hook = function()
    vim.cmd("normal! zz") -- Re-center after scrolling
  end,
  performance_mode = false,
  ignored_events = { 'WinScrolled', 'CursorMoved' },
})

