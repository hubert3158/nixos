require("render-markdown").setup({
  -- html: drop raw HTML decorations inside .md (kbd, details, sub, sup).
  -- Avoids the "html parser not installed" warning. Plain markdown still
  -- renders via the markdown/markdown_inline parsers.
  html = { enabled = false },
  -- latex: not using math; disables the utftex/latex2text dependency check.
  latex = { enabled = false },
})
