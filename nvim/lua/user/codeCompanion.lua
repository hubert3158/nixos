require("codecompanion").setup({
	opts = {
		log_level = "DEBUG", -- or "TRACE"
	},
	adapters = {
		anthropic = function()
			return require("codecompanion.adapters").extend("anthropic", {
				env = {
					api_key = "cmd: gpg --batch --quiet --decrypt ~/.password-store/keys/api/anthropic.gpg",
				},
			})
		end,
	},
})
