require("noice").setup({
  lsp = {
    -- Route LSP markdown through Noice's TreeSitter renderer.
    -- Silences the two healthcheck warnings and avoids the
    -- deprecated vim.lsp.util.* paths in nvim 0.12.
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
})
