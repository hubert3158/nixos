require("lint").linters.sqlfluff = {
	name = "sqlfluff",
	cmd = "sqlfluff",
	stdin = false,
	args = { "lint", "--dialect", "postgres", "--format", "json", "--nocolor" },
	stream = "stdout",
	ignore_exitcode = true,
	parser = require("lint.parser").from_errorformat("%f:%l:%c: %t%*[^:]: %m", {
		source = "sqlfluff",
		severity = {
			["L"] = vim.diagnostic.severity.WARN,
			["R"] = vim.diagnostic.severity.WARN,
			["C"] = vim.diagnostic.severity.WARN,
			["D"] = vim.diagnostic.severity.WARN,
			["S"] = vim.diagnostic.severity.WARN,
			["E"] = vim.diagnostic.severity.ERROR,
			["F"] = vim.diagnostic.severity.ERROR,
		},
	}),
}

require("lint").linters_by_ft = {
	markdown = { "markdownlint" }, -- No specific markdown LSP in your list; markdownlint is standard.
	yaml = { "yamllint" }, -- No specific YAML LSP in your list; yamllint is standard.
	dockerfile = { "hadolint" }, -- No specific Dockerfile LSP in your list; hadolint is standard.

	-- 2. Linters that strongly complement your existing LSPs.

	html = { "htmlhint" }, -- `htmlhint` offers more rules than basic `vscode-html-ls`.
	python = { "flake8" }, -- `flake8` is a standard complement to `pyright` (LSP) for style/bugs.

	sh = { "shellcheck" }, -- `shellcheck` is more comprehensive than `bashls` alone.
	bash = { "shellcheck" },

	terraform = { "tflint" },

	sql = { "sqlfluff" }, -- (Uncomment if you install and want to use sqlfluff for linting)
}
