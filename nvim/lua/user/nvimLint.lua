require("lint").linters_by_ft = {
	markdown = { "markdownlint" }, -- No specific markdown LSP in your list; markdownlint is standard.
	yaml = { "yamllint" }, -- No specific YAML LSP in your list; yamllint is standard.
	dockerfile = { "hadolint" }, -- No specific Dockerfile LSP in your list; hadolint is standard.

	-- 2. Linters that strongly complement your existing LSPs.

	html = { "htmlhint" }, -- `htmlhint` offers more rules than basic `vscode-html-ls`.
	css = { "stylelint" }, -- `stylelint` is much more powerful for CSS/SCSS/Less than `vscode-css-ls`.
	scss = { "stylelint" },
	less = { "stylelint" },
	python = { "flake8" }, -- `flake8` is a standard complement to `pyright` (LSP) for style/bugs.

	sh = { "shellcheck" }, -- `shellcheck` is more comprehensive than `bashls` alone.
	bash = { "shellcheck" },

	terraform = { "tflint" },

	sql = { "sqlfluff" }, -- (Uncomment if you install and want to use sqlfluff for linting)
}
