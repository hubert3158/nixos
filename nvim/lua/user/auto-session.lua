require("auto-session").setup({
  log_level = "error",
  auto_restore_last_session = false,
  git_use_branch_name = true,
  suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  session_lens = {
    -- false: load_on_setup=true forced the Telescope extension (and telescope
    -- itself) onto the eager startup path, defeating its DeferredUIEnter
    -- lazy-load. The lens loads itself on first use.
    load_on_setup = false,
    picker_opts = { border = true },
    previewer = false,
  },
})
