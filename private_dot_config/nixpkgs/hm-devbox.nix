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
    pkgs.terraform
    pkgs.curl
    pkgs.gnumake
    pkgs.go
    pkgs.golangci-lint
    pkgs.jq
    pkgs.nomad
    pkgs.consul
    pkgs.ansible
    pkgs.bind # provides nslookup
    pkgs.postgresql_15 # provides psql
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
