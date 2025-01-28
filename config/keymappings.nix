{ self, ... }: {
  keymaps = [
    { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options = { desc = "Find Files"; }; }
    { mode = "n"; key = "<leader>fo"; action = "<cmd>Telescope oldfiles<CR>"; options = { desc = "Find Old Files"; }; }
    { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options = { desc = "Live Grep"; }; }
    { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; options = { desc = "Find Buffers"; }; }
    { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>"; options = { desc = "Find Help Tags"; }; }
    { mode = "n"; key = "<leader>fs"; action = "<cmd>Telescope builtin<CR>"; options = { desc = "Search Telescope Builtins"; }; }
    { mode = "n"; key = "<leader>fc"; action = "<cmd>Telescope commands<CR>"; options = { desc = "Find Commands"; }; }
    { mode = "n"; key = "<leader>fk"; action = "<cmd>Telescope keymaps<CR>"; options = { desc = "Find Keymaps"; }; }
    { mode = "n"; key = "<leader>fm"; action = "<cmd>Telescope marks<CR>"; options = { desc = "Find Marks"; }; }
    { mode = "n"; key = "<leader>nf"; action = ":NERDTreeFind<CR>"; options = { desc = "Focus NERDTree"; }; }
    { mode = "n"; key = "<leader>nt"; action = ":NERDTreeToggle<CR>"; options = { desc = "Toggle NERDTree"; }; }
    { mode = "n"; key = "<leader>nn"; action = ":Neoformat<CR>"; options = { desc = "[N]eo[F]ormat"; }; }
    { mode = "n"; key = "<leader>nc"; action = ":lua require'neogen'.generate()<CR>"; options = { desc = "[C]omment Documentation Generation"; }; }
    { mode = "n"; key = "<leader>t"; action = ":tabnew<CR>"; options = { desc = "New Tab"; }; }
    { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options = { desc = "Quit"; }; }
    { mode = "n"; key = "<leader>l"; action = ":tabnext<CR>"; options = { desc = "Next Tab"; }; }
    { mode = "n"; key = "<leader>h"; action = ":tabprevious<CR>"; options = { desc = "Previous Tab"; }; }
    { mode = "n"; key = "<leader>1"; action = "1gt<CR>"; options = { desc = "Go to Tab 1"; }; }
    { mode = "n"; key = "<leader>2"; action = "2gt<CR>"; options = { desc = "Go to Tab 2"; }; }
    { mode = "n"; key = "<leader>3"; action = "3gt<CR>"; options = { desc = "Go to Tab 3"; }; }
    { mode = "n"; key = "<leader>4"; action = "4gt<CR>"; options = { desc = "Go to Tab 4"; }; }
    { mode = "n"; key = "<leader>5"; action = "5gt<CR>"; options = { desc = "Go to Tab 5"; }; }
    { mode = "n"; key = "<leader>bn"; action = ":bnext<CR>"; options = { desc = "Next Buffer"; }; }
    { mode = "n"; key = "<leader>bp"; action = ":bprevious<CR>"; options = { desc = "Previous Buffer"; }; }
    { mode = "n"; key = "<leader>bd"; action = ":bd<CR>"; options = { desc = "Close Buffer"; }; }
    { mode = "n"; key = "<leader>sv"; action = ":vsp<CR>"; options = { desc = "Vertical Split"; }; }
    { mode = "n"; key = "<leader>sh"; action = ":sp<CR>"; options = { desc = "Horizontal Split"; }; }
    { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options = { desc = "Move to Left Window"; }; }
    { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options = { desc = "Move to Lower Window"; }; }
    { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options = { desc = "Move to Upper Window"; }; }
    { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options = { desc = "Move to Right Window"; }; }
    { mode = "n"; key = "<C-Up>"; action = ":resize -2<CR>"; options = { desc = "Decrease Window Height"; }; }
    { mode = "n"; key = "<C-Down>"; action = ":resize +2<CR>"; options = { desc = "Increase Window Height"; }; }
    { mode = "n"; key = "<C-Left>"; action = ":vertical resize -2<CR>"; options = { desc = "Decrease Window Width"; }; }
    { mode = "n"; key = "<C-Right>"; action = ":vertical resize +2<CR>"; options = { desc = "Increase Window Width"; }; }
    { mode = "n"; key = "<leader>w="; action = ":vertical resize +5<CR>"; options = { desc = "Increase Window Width"; }; }
    { mode = "n"; key = "<leader>w-"; action = ":vertical resize -5<CR>"; options = { desc = "Decrease Window Width"; }; }
    { mode = "n"; key = "<A-j>"; action = ":m .+1<CR>=="; options = { desc = "Move Line Down"; }; }
    { mode = "n"; key = "<A-k>"; action = ":m .-2<CR>=="; options = { desc = "Move Line Up"; }; }
    { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; options = { desc = "Move Selection Down"; }; }
    { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; options = { desc = "Move Selection Up"; }; }
    { mode = "v"; key = "<"; action = "<gv"; options = { desc = "Indent Left and Reselect"; }; }
    { mode = "v"; key = ">"; action = ">gv"; options = { desc = "Indent Right and Reselect"; }; }
    { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options = { desc = "Save File"; }; }
    { mode = "n"; key = "<leader>qa"; action = ":qa!<CR>"; options = { desc = "Quit All"; }; }
{ mode = "v"; key = "<leader>y"; action = "\"+y"; options = { desc = "Yank to System Clipboard"; }; }
    { mode = "n"; key = "<leader>Y"; action = "gg\"+yG"; options = { desc = "Yank Entire Buffer to Clipboard"; }; }
    { mode = "n"; key = "<leader>p"; action = "\"+p"; options = { desc = "Paste from System Clipboard"; }; }
    { mode = "n"; key = "<leader>P"; action = "\"+P"; options = { desc = "Paste Before from System Clipboard"; }; }
    { mode = "n"; key = "<leader>sr"; action = ":%s/\\<<C-r><C-w>\\>//g<Left><Left>"; options = { desc = "Search and Replace Word Under Cursor"; }; }
    { mode = "n"; key = "<leader>ln"; action = ":set relativenumber!<CR>"; options = { desc = "Toggle Relative Line Numbers"; }; }
    { mode = "n"; key = "<leader>c"; action = ":nohlsearch<CR>"; options = { desc = "Clear Search Highlighting"; }; }
    { mode = "n"; key = "<leader>ve"; action = ":e $MYVIMRC<CR>"; options = { desc = "Edit Neovim Config"; }; }
    { mode = "n"; key = "<leader>vs"; action = ":source $MYVIMRC<CR>"; options = { desc = "Source Neovim Config"; }; }
    { mode = "n"; key = "<leader>sp"; action = ":set spell!<CR>"; options = { desc = "Toggle Spell Check"; }; }
    { mode = "n"; key = "<leader>gs"; action = ":Git<CR>"; options = { desc = "Git Status"; }; }
    { mode = "n"; key = "<leader>gc"; action = ":Git commit<CR>"; options = { desc = "Git Commit"; }; }
    { mode = "n"; key = "<leader>gp"; action = ":Git push<CR>"; options = { desc = "Git Push"; }; }
    { mode = "n"; key = "<leader>wr"; action = ":set wrap!<CR>"; options = { desc = "Toggle Wrap Mode"; }; }
    { mode = "n"; key = "<leader>bd"; action = ":bd<CR>"; options = { desc = "Close Buffer"; }; }
    { mode = "n"; key = "]q"; action = ":cnext<CR>"; options = { desc = "Next Quickfix Item"; }; }
    { mode = "n"; key = "[q"; action = ":cprev<CR>"; options = { desc = "Previous Quickfix Item"; }; }
    { mode = "n"; key = "<leader><F5>"; action = ":UndotreeToggle<CR>"; options = { desc = "Toggle Undo Tree"; }; }
    { mode = "n"; key = "<leader>un"; action = ":lua require('notify').dismiss({ silent = true, pending = true })<CR>"; options = { desc = "Dismiss Notifications"; }; }
    { mode = "n"; key = "<leader>tt"; action = "<cmd>ToggleTerm<CR>"; options = { desc = "Toggle Terminal"; }; }
    { mode = "n"; key = "<leader>/"; action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>"; options = { desc = "Toggle Comment"; }; }
    { mode = "v"; key = "<leader>/"; action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"; options = { desc = "Toggle Comment in Selection"; }; }
    { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options = { desc = "Toggle Diagnostics (Trouble)"; }; }
    { mode = "n"; key = "<leader>xX"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>"; options = { desc = "Toggle Diagnostics for Buffer (Trouble)"; }; }
    { mode = "n"; key = "<leader>cs"; action = "<cmd>Trouble symbols toggle focus=false<CR>"; options = { desc = "Toggle Symbols (Trouble)"; }; }
    { mode = "n"; key = "<leader>cl"; action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>"; options = { desc = "Toggle LSP (Trouble)"; }; }
    { mode = "n"; key = "<leader>xL"; action = "<cmd>Trouble loclist toggle<CR>"; options = { desc = "Toggle Location List (Trouble)"; }; }
    { mode = "n"; key = "<leader>xQ"; action = "<cmd>Trouble qflist toggle<CR>"; options = { desc = "Toggle Quickfix List (Trouble)"; }; }
    { mode = "n"; key = "<leader>xt"; action = "<cmd>Trouble todo<CR>"; options = { desc = "Show TODOs (Trouble)"; }; }
    { mode = "n"; key = "<leader>xT"; action = "<cmd>TodoTelescope<CR>"; options = { desc = "Search TODOs with Telescope"; }; }
    { mode = "n"; key = "<leader>cd"; action = "<cmd>Telescope zoxide list<CR>"; options = { desc = "Zoxide Directory Jump"; }; }
    { mode = "n"; key = "<leader>mo"; action = ":lua require'mini.map'.open()<CR>"; options = { desc = "Open Mini Map"; }; }
    { mode = "n"; key = "<leader>mc"; action = ":lua require'mini.map'.close()<CR>"; options = { desc = "Close Mini Map"; }; }
    { mode = "n"; key = "<leader>mt"; action = ":lua require'mini.map'.toggle()<CR>"; options = { desc = "Toggle Mini Map"; }; }
    { mode = "n"; key = "<leader>y"; action = ":lua require'yazi'.yazi()<CR>"; options = { desc = "Open [Y]azi"; }; }
    { mode = "n"; key = "<leader>gg"; action = ":LazyGit<CR>"; options = { desc = "Lazy [[G]]it"; }; }
  ];
}
