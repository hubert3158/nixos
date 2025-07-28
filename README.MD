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

`nvim-treesitter` may attempt to build the `kulala_http` parser in the plugin
directory. Because plugins are stored inside the read‑only `/nix/store` this
fails with errors such as:

```
Compiling...
Treesitter parser for kulala_http has been installed
Failed to install kulala_http parser. Please check your nvim-treesitter setup.
```

The maintainers recommend compiling the parser ahead of time with Nix and
adding it to `grammarPackages`.  Below is an example based on
[mistweaverco/kulala.nvim#627](https://github.com/mistweaverco/kulala.nvim/issues/627)
that fetches the grammar source and registers it with `nvim-treesitter`:

```nix
{ config, pkgs, ... }:
let
  treesitter-kulala-http = pkgs.tree-sitter.buildGrammar {
    language = "kulala_http";
    version = "5.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "mistweaverco";
      repo = "kulala.nvim";
      rev = "902fc21e8a3fee7ccace37784879327baa6d1ece";
      hash = "sha256-whQpwZMEvD62lgCrnNryrEvfSwLJJ+IqVCywTq78Vf8=";
    };
    location = "lua/tree-sitter";
  };
in {
  plugins.treesitter = {
    enable = true;
    grammarPackages =
      pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++
      [ treesitter-kulala-http ];
    luaConfig.post = ''
      do
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.kulala_http = {
          install_info = {
            url = "${treesitter-kulala-http}",
            files = {"src/parser.c"},
          },
          filetype = "kulala_http",
        }
      end
    '';
  };
}
```

With the parser built during the Nix build, Neovim no longer tries to compile
it at runtime and the read‑only store is not an issue.

This repository includes the above setup.  The Neovim wrapper exposes the parser
path via the `KULALA_HTTP_PARSER` environment variable and
`nvim/plugin/treesitter.lua` registers the parser if that variable is present.
