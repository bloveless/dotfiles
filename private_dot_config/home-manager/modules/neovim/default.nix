{ config, pkgs, lib, ... }:
let
  fromGitHub = owner: repo: ref: hash:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = ref;
        sha256 = hash;
      };
    };

in
{
  home.packages = with pkgs; [
    rust-analyzer
    lua-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # dashboard
      alpha-nvim

      # ui
      catppuccin-nvim
      nvim-web-devicons
      nvim-notify
      lualine-nvim
      dressing-nvim
      nvim-navic
      noice-nvim
      nui-nvim

      persistence-nvim
      alpha-nvim
      neo-tree-nvim

      # basics
      indent-blankline-nvim
      gitsigns-nvim
      todo-comments-nvim
      vim-illuminate
      lazygit-nvim

      trouble-nvim

      #neotest
      #neotest-go
      #neotest-rust
      #neotest-jest
      #harpoon
      #vim-fugitive
      #vim-abolish
      #vim-repeat
      #vim-eunuch
      vim-sleuth
      #vim-speeddating
      #auto-session
      telescope-nvim
      telescope-fzf-native-nvim
      #telescope-github-nvim
      #auto-hlsearch-nvim
      #zk-nvim

      (fromGitHub "echasnovski" "mini.indentscope" "f60e9b51a6214c73a170ffc5445ce91560981031" "sha256-lqy5GMi0J90X7TDrp4ao5Mp6FmBascfJhLjLurq1TMA=")
      (fromGitHub "davidmh" "cspell.nvim" "0e9c586bd7f7ab3f1f2f000a084121203e0ee62c" "sha256-wPzivrgKK22baYEqCOTpPbeXNtwGWsN4z08OoKYcxPM=")

      # coding
      nvim-lspconfig
      #null-ls-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-emoji
      cmp-calc
      nvim-cmp
      #nvim-autopairs
      #nvim-ts-autotag
      cmp-nvim-lsp-signature-help
      luasnip
      cmp_luasnip
      #friendly-snippets
      #neodev-nvim
      nvim-surround
      comment-nvim
      #treesj
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          #bash
          #cpp
          #css
          #diff
          #dockerfile
          #fish
          #git_config
          #git_rebase
          #gitattributes
          #gitcommit
          #gitignore
          #go
          #gomod
          #gowork
          #graphql
          #hcl
          #html
          #http
          javascript
          jq
          json
          lua
          make
          markdown
          markdown_inline
          #nix
          #python
          #query
          regex
          rust
          #scss
          #sql
          terraform
          #toml
          typescript
          #vhs
          vim
          yaml
          #zig
        ]))
      nvim-treesitter-textobjects
      nvim-treesitter-context
      nvim-treesitter-endwise
      #other-nvim

      # debug
      #nvim-dap
      #nvim-dap-ui
      #nvim-dap-go
      #telescope-dap-nvim
      #nvim-dap-virtual-text
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
