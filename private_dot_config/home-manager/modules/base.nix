{ config, fetchFromGitHub, nixpkgs, pkgs, lib, ... }:
{
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  ];

  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ll = "ls -la";
    l = "ls -l";
    wk = "watch kubectl";
    k = "kubectl";
    ku = "kubectl -n utils";
    km = "kubectl -n mayastor";
    kmo = "kubectl -n monitoring";
    kfs = "kubectl -n flux-system";
    kks = "kubectl -n kube-system";
    ka = "kubectl -n argo";
    kac = "kubectl -n argocd";
    kaw = "kubectl -n argo-workflows";
    kbl = "kubectl -n brennonloveless-com";
    kcm = "kubectl -n cert-manager";
    kp = "kubectl -n postgres";
    kpc = "kubectl -n projectcontour";
    kpg = "kubectl -n pod-gateway";
    kos = "kubectl -n openebs-system";
    ks = "kubectl -n secrets";
    kms = "kubectl -n media-server";
    ktp = "kubectl -n tekton-pipelines";
    tf = "terraform";
    cgit = "chezmoi git";
    terrafrom = "terraform";
    hm-home = "(cd $HOME/.config/home-manager && nix run . switch -- --flake \".#home\" --impure)";
    hm-work= "(cd $HOME/.config/home-manager && nix run . switch -- --flake \".#work\" --impure)";
    hm-devbox= "(cd $HOME/.config/home-manager && nix run . switch -- --flake \".#devbox\" --impure)";
  };

  home.file.".ideavimrc".text = ''
"
" Make sure to update https://gist.github.com/bloveless/e45e97de38f2eeeddc5ff296ed241caf when updating.
"

let mapleader = " "
set clipboard += unnamed
set ideajoin
set surround
set commentary
set which-key
set sneak
set incsearch
set visualbell
set noerrorbells
set number relativenumber
set ignorecase
set smartcase
set scrolloff=10

set NERDTree

" Change the Ctrl+E and Ctrl+Y speed to scroll 5 lines at a time.
" Using noremap is required so we don't get into an infinite loop.

nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

nnoremap <leader>si :source ~/.ideavimrc<CR>
nnoremap <leader>e :NERDTreeToggle<cr>
" Actions aren't supposed to use remap
map <leader>f <Action>(ReformatCode)
" map <leader>f <Action>(GotoFile)
map <leader>g <Action>(FindInPath)
map <leader>b <Action>(Switcher)
nnoremap [[ :action MethodUp<CR>
nnoremap ]] :action MethodDown<CR>
nnoremap ]d :action GotoNextError<CR>
nnoremap [d :action GotoPreviousError<CR>
nnoremap ]c :action VcsShowNextChangeMarker<CR>
nnoremap [c :action VcsShowPrevChangeMarker<CR>
nnoremap gi :action GotoImplementation<CR>
nnoremap <space>fu :action FindUsages<CR>

" Don't use Ex mode, use Q for formatting.
map Q gq

" map <leader>ff <Action>(GoToFile)
" map K <Action>(QuickJavaDoc)
map <leader>i <Action>(QuickImplementations)
map K <Action>(ShowErrorDescription)
command! Format action ReformatCode
  '';

  programs.fish = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    defaultKeymap = "emacs";

    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    #   {
    #     name = "powerlevel10k-config";
    #     src = lib.cleanSource ./p10k-config;
    #     file = "p10k.zsh";
    #   }
    # ];

    # Backup for when /etc/zshrc gets changed by every macos upgrade
    initExtra = "

      # Make nix work correctly on work computer
      if [ -e '/etc/ssl/certs/allCAbundle.pem' ]; then
        export NIX_SSL_CERT_FILE=/etc/ssl/certs/allCAbundle.pem
      fi

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi


      # Warpify subshells. Keep at the end of initExtra
      printf '\\eP$f{\"hook\": \"SourcedRcFileForWarp\", \"value\": { \"shell\": \"zsh\" }}\\x9c'
    ";

    profileExtra = "
      unsetopt inc_append_history
      unsetopt share_history

      argocd()
      {
        trap reset_namespace EXIT INT
        kubectl config set-context --current --namespace=argocd 2>&1 > /dev/null;
        command argocd \"$@\";
      }

      reset_namespace()
      {
        kubectl config set-context --current --namespace=default 2>&1 > /dev/null;
      }
    ";
  };

  programs.git = {
    enable = true;
    userName = "Brennon Loveless";
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # programs.neovim = {
  #   enable = true;

  #   package = pkgs.neovim-unwrapped;

  #   # Alias `vim` to nvim
  #   vimAlias = true;
  # };

  # home.file.".config/nvim" = {
  #   source = ../neovim;
  #   recursive = true;
  # };

  # programs.starship = {
  #   enable = true;
  #   # Configuration written to ~/.config/starship.toml
  #   settings = {
  #     # Get editor completions based on the config schema
  #     "$schema" = ''https://starship.rs/config-schema.json'';
  #
  #     command_timeout = 2000;
  #
  #     # Inserts a blank line between shell prompts
  #     add_newline = true;
  #
  #     cmd_duration = {
  #       min_time = 0;
  #     };
  #   } // builtins.fromTOML (builtins.readFile ../modules/tokyo-night/preset.toml);
  # };

  home.file.".npmrc".text = ''
    prefix = "~/.npm-global"
  '';

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    newSession = true;
    terminal = "screen-256color";
    shell ="${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
        '';
      }
    ];
    extraConfig = ''
      set-option -sa terminal-features ',alacritty:RGB,screen-256color:RGB,xterm-256color:RGB,xterm-kitty:RGB'

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Move window to the left and right
      bind -n C-S-Left swap-window -t -1\; select-window -t -1
      bind -n C-S-Right swap-window -t +1\; select-window -t +1

      # Default to opening new windows and splits in the same directory
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Enable mouse mode (tmux 2.1 and above)
      set -g mouse on

      # don't rename windows automatically
      set-option -g allow-rename off

      # Settings for vim
      set-option -g focus-events on
      set-option -sg escape-time 10

      # Much larger history limit
      set-option -g history-limit 100000
    '';
  };
}
