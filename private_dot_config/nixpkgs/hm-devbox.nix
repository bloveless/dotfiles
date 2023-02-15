{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  home.packages = [
    pkgs.git
    pkgs.kitty
    pkgs.file
    pkgs.chezmoi
    pkgs.terraform
    pkgs.curl
    pkgs.gnumake
    pkgs.go
    pkgs.golangci-lint
    pkgs.jq
    pkgs.nomad
    pkgs.consul
    pkgs.ansible
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
