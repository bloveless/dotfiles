{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  home.packages = [
    pkgs.ripgrep
    pkgs.git
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.aws-sam-cli
    pkgs.ssm-session-manager-plugin
    pkgs.terraform
    pkgs.ripgrep
    pkgs.curl
    pkgs.hugo
    pkgs.go
    pkgs.golangci-lint
    pkgs.jq
    nixpkgs.legacyPackages.x86_64-linux.qmk
    pkgs.nomad
    pkgs.consul
  ];

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };
}
