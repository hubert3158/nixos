{ self, ... }: {
  globalOpts = {
    # Line numbers
    number = true;
    relativenumber = true;

    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "yes";

    # Enable mouse
    mouse = "a";

    # Search settings
    ignorecase = true;
    smartcase = true;
    incsearch = true; # Do incremental searching

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    list = true;
    # NOTE: .__raw here means that this field is raw lua code
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Tab & indentation settings
    tabstop = 4;      # Number of spaces a <Tab> counts for
    shiftwidth = 4;   # Number of spaces for each step of (auto)indent
    softtabstop = 0;
    expandtab = true; # Convert tabs to spaces
    smarttab = true;

    # System clipboard support, needs xclip/wl-clipboard
    clipboard = {
      providers = {
        wl-copy.enable = true; # Wayland 
        xsel.enable = true;    # For X11
      };
      register = "unnamedplus";
    };

    # Save undo history
    undofile = true;

    # Cursor settings
    cursorline = true;

    # Show line and column when searching
    ruler = true;

    # Global substitution by default
    gdefault = true;

    # Start scrolling when the cursor is X lines away from the top/bottom
    scrolloff = 6;
  };

  # Set leader keys
  globals.mapleader = " ";
  globals.maplocalleader = ",";

  # User-defined commands
  userCommands = {
    Q.command = "q";
    Q.bang = true;
    Wq.command = "q";
    Wq.bang = true;
    WQ.command = "q";
    WQ.bang = true;
    W.command = "q";
    W.bang = true;
  };

  # Auto-save when focus is lost
  autoCmd = [
    {
      event = [ "FocusLost" ];
      pattern = [ "*" ];
      command = "silent! wa";
    }
    # {
    #   event = [ "VimEnter" ];
    #   callback = { __raw = "function() if vim.fn.argv(0) == '' then require('telescope.builtin').find_files() end end"; };
    # }
  ];

  # Highlight settings
  highlight = {
    Comment.fg = "#ff00ff";
    Comment.bg = "#000000";
    Comment.underline = true;
    Comment.bold = true;
  };
}

