require('neoscroll').setup({
  mappings = { '<C-u>', '<C-d>' },
  hide_cursor = true,
  stop_eof = true,
  respect_scrolloff = false,
  cursor_scrolls_alone = true,
  duration_multiplier = 0.5, -- Faster animations
  easing = 'linear',
  pre_hook = nil,
  post_hook = nil, -- Removed re-centering for better performance
  performance_mode = true, -- Enable performance mode
  ignored_events = { 'WinScrolled', 'CursorMoved' },
})

