require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },

		-- Web
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		less = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		graphql = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },

		-- Backend / System
		go = { "goimports", "gofmt" }, -- goimports includes gofmt
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		-- cs = { "csharpier" }, -- if you do C#
		-- php = { "php-cs-fixer" }, -- if you do PHP
		-- ruby = { "rubocop" }, -- if you do Ruby
		sh = { "shfmt" },
		bash = { "shfmt" },
		sql = { "pg_format", "sqlfluff", "prettierd", "prettier", stop_after_first = true },
		nix = { "alejandra" },
		java = { "google-java-format" },
		toml = { "taplo" },
		-- dockerfile = { "dfmt" },
		terraform = { "terraform_fmt" },
	},

	-- Optional: Global format options
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true, -- Fallback to LSP formatting if conform fails
	},

	-- Optional: For formatters like prettierd that can run as daemons
	-- formatters = {
	--   prettierd = {
	--     env = {
	--       PRETTIERD_DEFAULT_CONFIG = "/path/to/your/.prettierrc.json" -- if needed
	--     }
	--   }
	-- }
})
