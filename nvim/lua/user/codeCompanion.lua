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
		anthropic = function()
			return require("codecompanion.adapters").extend("anthropic", {
				env = {
					api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/anthropic.gpg",
				},
				params = {
					temperature = 0.1, -- More deterministic responses
					max_tokens = 4000, -- Longer response capability
					top_p = 0.9,
				},
			})
		end,
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				env = {
					api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/openai.gpg",
				},
				params = {
					model = "gpt-4.1",
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
	},
	cache = {
		enabled = true,
		path = vim.fn.stdpath("cache") .. "/codecompanion",
		ttl = 24 * 60 * 60, -- Cache duration: 24 hours
	},
})
