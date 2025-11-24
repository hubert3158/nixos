require("codecompanion").setup({
	opts = {
		log_level = "INFO",
	},
	loading = {
		enabled = true,
		text = "CodeCompanion working...",
		spinner = "moon",
	},
	-- 1. Group all adapters under 'http'
	adapters = {
		http = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/anthropic.gpg",
					},
					params = {
						model = "claude-sonnet-4-5",
						temperature = 0.1,
						max_tokens = 4000,
						thinking = false,
					},
				})
			end,

			openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/openai.gpg",
					},
					params = {
						model = "gpt-5",
						temperature = 0.1,
					},
				})
			end,

			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/gemini.gpg",
					},
					params = {
						model = "gemini-2.5-flash-preview-04-17",
						temperature = 0.1,
					},
				})
			end,

			-- 2. Minimax Fix (Switched to openai_compatible for URL control)
			minimax = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					name = "minimax",
					env = {
						-- Base URL only
						url = "https://api.minimax.chat/v1/text",
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/minimax.gpg",
						-- Specific endpoint suffix
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

			-- 3. Cerebras (Moved inside 'http' table)
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
								"gpt-oss-120b",
								"llama-3.3-70b",
								"llama3.1-8b",
								"zai-glm-4.6",
							},
							default = "zai-glm-4.6",
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

	cache = {
		enabled = true,
		path = vim.fn.stdpath("cache") .. "/codecompanion",
		ttl = 24 * 60 * 60,
	},
})
