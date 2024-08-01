require"surround".setup {
  context_offset = 100,
  load_autogroups = false,
  mappings_style = "sandwich",
  map_insert_mode = true,
  quotes = {"'", '"'},
  brackets = {"(", '{', '['},
  space_on_closing_char = false,
  pairs = {
    nestable = { b = { "(", ")" }, B = { "[", "]" }, c = { "{", "}" }, a = { "<", ">" } },
    linear = { q = { "'", "'" }, t = { "`", "`" }, d = { '"', '"' } }
  },
  prefix = "s"
}

-- b = brackets, B = Big brackets, c = Curly Braces, a = Angle brackets, q = quote, t = tilde, d = double quote
