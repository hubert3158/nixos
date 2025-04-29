require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },

		typescript = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		sql = { "sqlformat" },
		nix = { "alejandra" },
		java = { "google-java-format" },
	},
})
