-- Inline colour swatches.
--
-- `names` is off globally: the default (true) paints every occurrence of
-- "red" / "white" / "gray" / "tan" in prose and identifiers, which in a repo
-- full of Kanagawa comments turns ordinary words into confetti. Style sheets
-- are the one place named colours are real values, so they opt back in.
require("colorizer").setup({
	filetypes = {
		"*",
		css = { names = true },
		scss = { names = true },
		sass = { names = true },
		html = { names = true },
	},
	user_default_options = {
		names = false,
	},
})
