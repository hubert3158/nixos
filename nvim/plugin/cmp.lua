local cmp = require("blink.cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true })

cmp.setup({
	keymap = {
		preset = "default",
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
	},
	snippets = {
		preset = "luasnip",
	},
	completion = {
		accept = {
			create_undo_point = true,
			auto_brackets = {
				enabled = true,
				default_brackets = { "(", ")" },
				override_brackets_for_filetypes = {},
				force_allow_filetypes = {},
				blocked_filetypes = {},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			update_delay_ms = 50,
		},
		ghost_text = {
			enabled = true,
		},
		menu = {
			enabled = true,
			min_width = 15,
			max_height = 10,
			border = "none",
			winblend = 0,
			winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
			scrollbar = true,
			direction_priority = { "s", "n" },
			auto_show = true,
		},
		list = {
			selection = { preselect = true, auto_insert = true },
		},
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
			show_on_blocked_trigger_characters = {},
			show_on_x_blocked_trigger_characters = {},
		},
	},
	cmdline = {
		completion = {
			trigger = { show_on_blocked_trigger_characters = {}, show_on_x_blocked_trigger_characters = {} },
			list = { selection = { preselect = true, auto_insert = true } },
			menu = { auto_show = true },
			ghost_text = { enabled = true },
		},
	},
	signature = { enabled = true },
	sources = {
		default = {
			"lsp",
			"path",
			"buffer",
			"snippets",
			"codecompanion",
			"omni",
			"cmdline",
		},
		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp",
				enabled = true,
				transform_items = nil,
				should_show_items = true,
				max_items = nil,
				min_keyword_length = 0,
				fallbacks = { "buffer" },
				score_offset = 0,
				override = nil,
			},
			buffer = {
				name = "Buffer",
				module = "blink.cmp.sources.buffer",
				enabled = true,
				max_items = nil,
				min_keyword_length = 0,
				fallbacks = {},
				score_offset = -3,
			},
			snippets = {
				name = "Snippets",
				module = "blink.cmp.sources.snippets",
				enabled = true,
				max_items = nil,
				min_keyword_length = 0,
				fallbacks = {},
				score_offset = -1,
				should_show_items = true,
				opts = {},
			},
			path = {
				name = "Path",
				module = "blink.cmp.sources.path",
				enabled = true,
				max_items = nil,
				min_keyword_length = 0,
				fallbacks = {},
				score_offset = 3,
				opts = {
					trailing_slash = false,
					label_trailing_slash = true,
					get_cwd = function(context)
						return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
					end,
					show_hidden_files_by_default = false,
				},
			},
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
		},
		per_filetype = {
			sql = { "snippets", "dadbod", "buffer" },
		},
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})
