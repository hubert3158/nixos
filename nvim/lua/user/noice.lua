require("noice").setup({
  presets = {
    -- Render :IncRename input inline at the cursor
    inc_rename = true,
    -- Cmdline as a centered floating palette, search popup follows
    command_palette = true,
    -- Long messages route to a split instead of blocking hit-enter prompts
    long_message_to_split = true,
  },
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
