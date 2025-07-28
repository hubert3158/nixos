-- Fix Kulala Treesitter for NixOS (treesitter.lua)

-- Use Neovim config dir for parsers
local parser_install_dir = vim.fn.stdpath("config") .. "/treesitter-parsers"
-- Prepend to runtimepath so Treesitter finds our parsers
vim.opt.runtimepath:prepend(parser_install_dir)

-- Workaround: copy Kulala's bundled grammar to writable config dir
local fs = require("kulala.utils.fs")
local orig_get_plugin_path = fs.get_plugin_path
local plugin_src = orig_get_plugin_path({ "..", "tree-sitter" })
local local_src = parser_install_dir .. "/kulala_http"
vim.fn.mkdir(local_src, "p")
vim.fn.system({ "cp", "-r", plugin_src .. "/.", local_src })

-- Override Kulala's fs.get_plugin_path for grammar lookups
fs.get_plugin_path = function(paths)
	if paths and paths[1] == ".." and paths[2] == "tree-sitter" then
		local sub = vim.list_slice(paths, 3)
		return vim.fs.normalize(local_src .. "/" .. table.concat(sub, "/"))
	end
	return orig_get_plugin_path(paths)
end

-- Inject custom HTTP parser (used by Kulala) into Treesitter
---@type table<string, {install_info: table<string, any>, filetype: string}>
local configs = require("nvim-treesitter.parsers").get_parser_configs()
configs.http = {
	install_info = {
		url = local_src,
		files = { "src/parser.c" },
		generate_requires_npm = false,
		requires_generate_from_grammar = false,
	},
	filetype = "http",
}

-- Configure nvim-treesitter with full user settings
require("nvim-treesitter.configs").setup({
	modules = {},
	ensure_installed = {},
	parser_install_dir = parser_install_dir,
	sync_install = false,
	auto_install = false,
	ignore_install = { "http" },

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},

	textobjects = {
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

-- Initialize Kulala with our parser path
require("kulala").setup({ parser_install_dir = parser_install_dir })
print("nvim-treesitter + kulala fixed for NixOS (using http parser)")
