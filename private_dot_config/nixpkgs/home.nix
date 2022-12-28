{ config, fetchFromGitHub, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.packages = [
    pkgs.htop
    pkgs.cowsay
    pkgs.git
    pkgs.file
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.nodejs
    pkgs.nodePackages.aws-cdk
  ];

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];

  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ll = "ls -la";
    l = "ls -l";
    k = "kubectl";
    ku = "kubectl -n utils";
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
    zettel = "cd ~/zettelkasten; nvim -S";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.bash = {
    enable = true;
    profileExtra = ''
      if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
      fi
    '';
  };

  programs.zsh = {
    enable = true;
    profileExtra = ''
      if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
      fi
    '';
  };

  programs.neovim = {
    enable = true;

    # Alias `vim` to nvim
    vimAlias = true;
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # Get editor completions based on the config schema
      "$schema" = ''https://starship.rs/config-schema.json'';

      command_timeout = 2000;

      # Inserts a blank line between shell prompts
      add_newline = true;

      cmd_duration = {
        min_time = 0;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    newSession = true;
    terminal = "screen-256color";
    shell ="${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    plugins = with pkgs; [
      tmuxPlugins.nord
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",alacritty:Tc"
      # set-environment -g PATH "/usr/local/bin:/bin:/usr/bin:$HOME/.nix-profile/bin"

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

      # reload config file (change file location to your the tmux.conf you want to use)
      bind r source-file ~/.tmux.conf

      # Put status bar at the top
      # set-option -g status-position top

      # Create a second blank status bar to create padding between the status bar and text
      set -Fg 'status-format[1]' '#{status-format[0]}'
      set -g 'status-format[0]' '''
      set -g status 2

      # Enable mouse mode (tmux 2.1 and above)
      set -g mouse on

      # don't rename windows automatically
      set-option -g allow-rename off

      # Settings for vim
      set-option -g focus-events on
      set-option -sg escape-time 10
    '';
  };
}
