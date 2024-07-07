-- ~/.config/nvim/lua/telescope-config.lua
--

 vim.g.mapleader = " "

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Add picker-specific configurations here
  },
  extensions = {
    -- Add extension-specific configurations here
  }
}

