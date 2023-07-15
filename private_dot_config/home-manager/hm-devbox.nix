{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:
{
  # environment variables
  home.packages = [
    pkgs.ripgrep
    pkgs.git
    pkgs.file
    pkgs.chezmoi
    pkgs.curl
    pkgs.gnumake
    pkgs.talosctl
    pkgs.argocd
    pkgs.jq
    pkgs.ansible
    pkgs.bind # provides nslookup
    pkgs.postgresql_15 # provides psql
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.cilium-cli
    pkgs.nodejs # necessary for lsps to install with LspZero/Mason
    pkgs.unzip
    pkgs.cachix
    pkgs.fd # for neovim telescope
    pkgs.gcc # for neovim treesitter
  ];
  
  programs.zsh = {
    enable = true;
    profileExtra = ''
      if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
      fi
    '';
  };
}
