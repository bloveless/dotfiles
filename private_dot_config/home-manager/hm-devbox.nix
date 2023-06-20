{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  # environment variables
  home.sessionVariables = {
    NOMAD_ADDR = "http://192.168.5.20:4646";
    CONSUL_HTTP_ADDR = "192.168.5.20:8500";
  };

  home.packages = [
    pkgs.ripgrep
    pkgs.git
    pkgs.file
    pkgs.chezmoi
    pkgs.awscli2
    pkgs.k9s
    pkgs.terraform
    pkgs.curl
    pkgs.gnumake
    pkgs.go
    pkgs.golangci-lint
    pkgs.talosctl
    pkgs.argocd
    pkgs.jq
    pkgs.nomad
    pkgs.consul
    pkgs.ansible
    pkgs.bind # provides nslookup
    pkgs.postgresql_15 # provides psql
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.tfk8s
    pkgs.skaffold
    pkgs.kubeseal
    pkgs.cilium-cli
    pkgs.helix
    pkgs.rustup
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