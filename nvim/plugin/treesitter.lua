-- Or wherever you configure your plugins

-- Define the directory for storing Treesitter parsers (still needed by nvim-treesitter itself)
local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"

-- If the KULALA_HTTP_PARSER environment variable is set, register the
-- prebuilt parser directly with nvim-treesitter.  This avoids attempts to
-- compile the parser inside the read-only Nix store.
local kulala_parser = os.getenv("KULALA_HTTP_PARSER")
if kulala_parser then
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.kulala_http = {
    install_info = {
      url = kulala_parser,
      files = {"src/parser.c"},
    },
    filetype = "kulala_http",
  }
end

-- Configure nvim-treesitter
require("nvim-treesitter.configs").setup({
	modules = {},
	ensure_installed = {},
	-- Specify the installation directory for parsers
	parser_install_dir = parser_install_dir,

	-- Install parsers synchronously (blocking Neovim)
	sync_install = false,

	-- Automatically install missing parsers when opening a buffer
	-- Set to false if NixOS handles *all* parser installations reliably
	auto_install = false, -- Changed to false based on NixOS handling

	-- List of parsers to ignore installing (can be "all")
	ignore_install = {}, -- Keep empty or list specific parsers if needed

	-- Configure highlighting
	highlight = {
		enable = true,
		-- Disable highlighting for specific languages if needed
		-- disable = { "c", "rust" },
		additional_vim_regex_highlighting = false,
	},

	-- Configure indentation based on Treesitter
	indent = {
		enable = true,
		-- disable = { "yaml" },
	},

	-- Configure Treesitter textobjects
	textobjects = {
		-- Textobject selection module
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = { query = "@function.outer", desc = "Select outer function" },
				["if"] = { query = "@function.inner", desc = "Select inner function" },
				["ac"] = { query = "@class.outer", desc = "Select outer class" },
				["ic"] = { query = "@class.inner", desc = "Select inner class" },
				["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
				["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
				["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
				["a:"] = { query = "@parameter.outer", desc = "Select outer part of parameter/argument" },
				["i:"] = { query = "@parameter.inner", desc = "Select inner part of parameter/argument" },
			},
			selection_modes = {
				["@parameter.outer"] = "v",
				["@function.outer"] = "V",
				["@class.outer"] = "V",
				["@assignment.outer"] = "V",
				["@loop.outer"] = "V",
				["@conditional.outer"] = "V",
			},
			include_surrounding_whitespace = true,
		},

		-- Textobject movement module
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = { query = "@function.outer", desc = "Next function start" },
				["]]"] = { query = "@class.outer", desc = "Next class start" },
				["]o"] = { query = "@loop.*", desc = "Next loop start" },
				["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope start" },
				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold start" },
				["]?"] = { query = "@conditional.outer", desc = "Next conditional start" },
				["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "Next function end" },
				["]["] = { query = "@class.outer", desc = "Next class end" },
				["]O"] = { query = "@loop.*", desc = "Next loop end" },
				["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
			},
			goto_previous_start = {
				["[m"] = { query = "@function.outer", desc = "Previous function start" },
				["[["] = { query = "@class.outer", desc = "Previous class start" },
				["[o"] = { query = "@loop.*", desc = "Previous loop start" },
				["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope start" },
				["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold start" },
				["[?"] = { query = "@conditional.outer", desc = "Previous conditional start" },
				["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "Previous function end" },
				["[]"] = { query = "@class.outer", desc = "Previous class end" },
				["[O"] = { query = "@loop.*", desc = "Previous loop end" },
				["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
			},
		},

		-- LSP interop module for textobjects
		lsp_interop = {
			enable = true,
			border = "rounded",
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = { query = "@function.outer", desc = "Peek function definition" },
				["<leader>dF"] = { query = "@class.outer", desc = "Peek class definition" },
			},
		},
	},
})

require("kulala").setup({
	parser_install_dir = parser_install_dir,
})
print("nvim-treesitter configuration loaded.")
