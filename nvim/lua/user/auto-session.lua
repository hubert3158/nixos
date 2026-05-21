require("auto-session").setup({
  log_level = "error",
  auto_restore_last_session = false,
  git_use_branch_name = true,
  suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  session_lens = {
    load_on_setup = true,
    picker_opts = { border = true },
    previewer = false,
  },
})
