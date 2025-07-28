#
#run the following script
#
#cp -r /nix/store/301k2jhjanl6rr96b9yy9qzcrhjbwgmz-jdt-language-server-1.36.0/share/java/jdtls/config_linux /home/hubert/.jdtls_config
#chmod -R u+w /home/hubert/.jdtls_config



#rebuilds the the whole config including main configuration for ( work/home)
sudo nixos-rebuild switch --flake .#home --show-trace

#rebuilds the config only using home-manager
#run build.sh  -> okay???




## Fixing kulala.nvim parser errors on NixOS

`nvim-treesitter` may try to compile the `kulala_http` parser inside the plugin directory. On NixOS the plugin is stored in `/nix/store` which is read‑only, leading to errors such as:

```
Compiling...
Treesitter parser for kulala_http has been installed
Failed to install kulala_http parser. Please check your nvim-treesitter setup.
```

The workaround used in this repo copies the parser sources to a writable directory and overrides `kulala.utils.fs.get_plugin_path` so that `nvim-treesitter` installs to `$XDG_DATA_HOME/nvim/treesitter-parsers`. See issues [mistweaverco/kulala.nvim#627](https://github.com/mistweaverco/kulala.nvim/issues/627) and [mistweaverco/kulala.nvim#634](https://github.com/mistweaverco/kulala.nvim/issues/634) for context.

```lua
-- nvim/plugin/treesitter.lua
local fs = require("kulala.utils.fs")
local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"
local orig_get_plugin_path = fs.get_plugin_path
local ts_src = orig_get_plugin_path({ "..", "tree-sitter" })
local ts_dst = parser_install_dir .. "/kulala-tree-sitter"

if vim.fn.isdirectory(ts_dst) == 0 then
  vim.fn.mkdir(ts_dst, "p")
  vim.fn.system({ "cp", "-r", ts_src .. "/.", ts_dst })
end

fs.get_plugin_path = function(paths)
  if paths and paths[1] == ".." and paths[2] == "tree-sitter" then
    local rest = {}
    for i = 3, #paths do
      rest[#rest + 1] = paths[i]
    end
    return vim.fs.normalize(ts_dst .. "/" .. table.concat(rest, "/"))
  end
  return orig_get_plugin_path(paths)
end

require("kulala").setup({ parser_install_dir = parser_install_dir })
```
