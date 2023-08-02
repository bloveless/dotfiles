{ config, pkgs, lib, ... }:
let
  extraNodePackages = import ../node/default.nix {
    inherit pkgs;
  };
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
    nodePackages.typescript-language-server
    nodePackages.vscode-json-languageserver
    nodePackages.cspell
    efm-langserver
    extraNodePackages."@tailwindcss/language-server"
    lazygit
    terraform # used for terraform fmt and validate null-ls actions
    fd # for neovim telescope
    terraform-ls
    tflint
    taplo
    hadolint # dockerfile
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.svelte-language-server
    gopls
    gofumpt
    gotools
    goimports-reviser
    stylua
    luajitPackages.luacheck
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
      # neo-tree-nvim
      nvim-tree-lua

      # fidget-nvim fidget locked to legacy tag
      (fromGitHub "j-hui" "fidget.nvim" "90c22e47be057562ee9566bad313ad42d622c1d3" "sha256-N3O/AvsD6Ckd62kDEN4z/K5A3SZNR15DnQeZhH6/Rr0=")

      # (fromGitHub "ryu-ichiroh" "vim-cspell" "7713746127d24070e2e75b6e3e911cf275f2a745" "sha256-N3O/AvsD6Ckd62kDEN4z/K5A3SZNR15DnQeZhH6/Rr0=")

      # basics
      indent-blankline-nvim
      gitsigns-nvim
      todo-comments-nvim
      vim-illuminate
      lazygit-nvim

      trouble-nvim

      # lsp
      typescript-nvim
      rust-tools-nvim
      vim-terraform
      # crates-nvim

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

      (fromGitHub "ray-x" "guihua.lua" "9a15128d92dfba57ada2857316073d1fa3d97c93" "sha256-OlS89mX+AyyErQjRDWybqDrCvUdwopXdqwOR2QZeTmw=")

      (fromGitHub "creativenull" "efmls-configs-nvim" "4721dfdaf259318e94e90e65678cf214c7a5458c" "sha256-xTu3F1xTH+5ipJYhhVJmTe2T8vXS8Nh8mShQ486rOl8=")

      # coding
      nvim-lspconfig
      # null-ls-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-emoji
      cmp-calc
      nvim-cmp
      go-nvim
      #nvim-autopairs
      #nvim-ts-autotag
      cmp-nvim-lsp-signature-help
      luasnip
      cmp_luasnip
      #friendly-snippets
      #neodev-nvim
      nvim-surround

      (fromGitHub "echasnovski" "mini.comment" "877acea5b2a32ff55f808fc0ebe9aa898648318c" "sha256-oeXDsSlXHnVt2EcTlJZOdATs90TpWUX+yfKKhxALnZo=
")
      nvim-ts-context-commentstring

      #treesj
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          bash
          css
          diff
          dockerfile
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          gomod
          gowork
          gosum
          graphql
          hcl
          html
          http
          javascript
          jq
          json
          lua
          make
          markdown
          markdown_inline
          nix
          python
          query
          regex
          ron
          rust
          scss
          sql
          svelte
          terraform
          toml
          tsx
          typescript
          vhs
          vim
          yaml
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
