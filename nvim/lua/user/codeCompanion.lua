require("codecompanion").setup({
	opts = {
		log_level = "INFO", -- Use "DEBUG" or "TRACE" for troubleshooting
	},
	loading = {
		enabled = true,
		text = "CodeCompanion working...",
		spinner = "moon",
	},
	adapters = {
		http = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/anthropic.gpg",
					},
					params = {
						model = "claude-sonnet-4-5",
						temperature = 0.1, -- keep determinism
						-- top_p removed per 4.5 migration rules
						max_tokens = 4000, -- keep your current limit (plugin maps this)
						thinking = false, -- leave as-is unless you want visible extended thinking
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
			--          ╭─────────────────────────────────────────────────────────╮
			--          │                 MINI MAX IS NOT WORKING                 │
			--          ╰─────────────────────────────────────────────────────────╯
			minimax = function()
				return require("codecompanion.adapters").extend("openai", {
					name = "minimax",
					url = "https://api.minimax.chat/v1/text/chatcompletion_v2",
					env = {
						api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/minimax.gpg",
					},
					headers = {
						["Content-Type"] = "application/json",
						["Authorization"] = "Bearer ${api_key}",
					},
					params = {
						model = "MiniMax-Text-01",
						temperature = 0.1,
						max_tokens = 4000,
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
						topic = "general", -- "general" or "news"
						search_depth = "advanced", -- "basic" or "advanced"
						chunks_per_source = 3,
						max_results = 3,
						include_answer = true,
						include_raw_content = false,
						-- Optional: time_range = "week", include_domains = {"example.com"},
					},
				})
			end,
		},
	},
	cache = {
		enabled = true,
		path = vim.fn.stdpath("cache") .. "/codecompanion",
		ttl = 24 * 60 * 60, -- Cache duration: 24 hours
	},
})
