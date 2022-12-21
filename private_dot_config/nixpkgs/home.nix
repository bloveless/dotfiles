{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bloveless";
  home.homeDirectory = "/Users/bloveless";
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

  programs.bash.enable = true;
  programs.zsh.enable = true;

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
}
