require('git-conflict').setup({
  default_mappings = true, -- disable buffer local mapping created by this plugin
  default_commands = true, -- disable commands created by this plugin
  disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  list_opener = 'copen', -- command or function to open the conflicts list
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffAdd',
    current = 'DiffText',
  }
})

-- Key mappings for git conflict resolution
vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)', { desc = 'Choose ours (current branch)' })
vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)', { desc = 'Choose theirs (incoming branch)' })
vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)', { desc = 'Choose both' })
vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)', { desc = 'Choose none' })
vim.keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = 'Previous conflict' })
vim.keymap.set('n', '[x', '<Plug>(git-conflict-next-conflict)', { desc = 'Next conflict' })

-- Commands available:
-- :GitConflictChooseOurs — Select the current changes.
-- :GitConflictChooseTheirs — Select the incoming changes.
-- :GitConflictChooseBoth — Select both changes.
-- :GitConflictChooseNone — Select none of the changes.
-- :GitConflictNextConflict — Move to the next conflict.
-- :GitConflictPrevConflict — Move to the previous conflict.
-- :GitConflictListQf — Get all conflict to quickfix