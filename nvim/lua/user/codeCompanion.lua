require("codecompanion").setup({
	opts = {
		log_level = "INFO",
	},

	-- Specify which adapter to use for each interaction type
	interactions = {
		chat = {
			adapter = "cerebras",
			-- Agentic tools
			tools = {
				groups = { "full_stack_dev" },
				opts = {
					auto_submit_errors = true,
					auto_submit_success = true,
				},
			},
			-- Slash commands
			slash_commands = {
				buffer = { opts = { provider = "telescope" } },
				file = { opts = { provider = "telescope" } },
				symbols = { enabled = true },
				fetch = { enabled = true },
				terminal = { enabled = true },
				help = { enabled = true },
			},
			-- Variables
			variables = {
				buffer = { enabled = true },
				lsp = { enabled = true },
				viewport = { enabled = true },
			},
			-- Rules - auto-load CLAUDE.md, .cursorrules, etc.
			rules = {
				autoload = { "default" },
			},
		},
		inline = {
			adapter = "anthropic",
		},
		cmd = {
			adapter = "anthropic",
		},
		background = {
			adapter = "gemini", -- Cheaper for auto-titling
		},
	},

	-- Display options
	display = {
		chat = {
			window = {
				layout = "vertical",
				width = 0.4,
				border = "rounded",
			},
			show_settings = false,
		},
		diff = {
			provider = "mini_diff",
		},
		action_palette = {
			provider = "telescope",
		},
	},

	-- Prompt library with workflows
	prompt_library = {
		["Edit and Test"] = {
			interaction = "chat",
			opts = { is_workflow = true },
			prompts = {
				{
					role = "user",
					content = "Edit the code as requested, then run the tests. Keep iterating until tests pass.",
					opts = { auto_submit = false },
				},
			},
		},
	},

	adapters = {
		http = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/anthropic.gpg",
					},
					schema = {
						model = {
							default = "claude-sonnet-4-5-20250929",
						},
						max_tokens = {
							default = 16000,
						},
						extended_thinking = {
							default = false,
						},
					},
				})
			end,

			openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/openai.gpg",
					},
					schema = {
						model = {
							default = "gpt-5.2",
						},
						temperature = {
							default = 0.1,
						},
					},
				})
			end,

			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/gemini.gpg",
					},
					schema = {
						model = {
							default = "gemini-3-flash",
						},
						temperature = {
							default = 0.1,
						},
					},
				})
			end,

			minimax = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					name = "minimax",
					env = {
						url = "https://api.minimax.chat/v1/text",
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/minimax.gpg",
						chat_url = "/chatcompletion_v2",
					},
					headers = {
						["Content-Type"] = "application/json",
						["Authorization"] = "Bearer ${api_key}",
					},
					schema = {
						model = {
							default = "MiniMax-Text-01",
						},
						temperature = {
							default = 0.1,
						},
						max_tokens = {
							default = 4000,
						},
					},
				})
			end,

			tavily = function()
				return require("codecompanion.adapters").extend("tavily", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/tavily.gpg",
					},
					opts = {
						topic = "general",
						search_depth = "advanced",
						chunks_per_source = 3,
						max_results = 3,
						include_answer = true,
						include_raw_content = false,
					},
				})
			end,

			cerebras = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					name = "cerebras",
					env = {
						url = "https://api.cerebras.ai/v1",
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/cerebras.gpg",
						chat_url = "/chat/completions",
					},
					schema = {
						model = {
							choices = {
								"zai-glm-4.7",
								"llama-3.3-70b",
								"llama3.1-8b",
							},
							default = "zai-glm-4.7",
						},
						temperature = {
							default = 0.1,
						},
						max_tokens = {
							default = 4000,
						},
					},
				})
			end,
		},
	},
})

-- Keymaps
vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc = "Open chat" })
vim.keymap.set("n", "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "Actions" })
vim.keymap.set({ "n", "v" }, "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle chat" })
vim.keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<cr>", { desc = "Inline assistant" })
vim.keymap.set("v", "<leader>ci", "<cmd>CodeCompanion<cr>", { desc = "Inline assistant" })
vim.keymap.set("n", "<leader>cb", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add buffer to chat" })
vim.keymap.set("v", "<leader>cv", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to chat" })
vim.keymap.set("n", "<leader>cs", "<cmd>CodeCompanionChat Stop<cr>", { desc = "Stop request" })
vim.keymap.set("v", "<leader>ce", "<cmd>CodeCompanion /explain<cr>", { desc = "Explain code" })
vim.keymap.set("v", "<leader>cr", "<cmd>CodeCompanion /review<cr>", { desc = "Review code" })
vim.keymap.set("v", "<leader>cx", "<cmd>CodeCompanion /fix<cr>", { desc = "Fix code" })
