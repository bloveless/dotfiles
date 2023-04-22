{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  home.packages = [
    pkgs.ripgrep
    pkgs.git
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    pkgs.nodejs
    pkgs.yarn
    pkgs.argocd
    pkgs.nodePackages.aws-cdk
    pkgs.nodePackages.redoc-cli
    pkgs.terraform
    pkgs.ripgrep
    pkgs.curl
    pkgs.go
    pkgs.golangci-lint
    pkgs.jq
    pkgs.nomad
    pkgs.consul
    pkgs.postgresql_15
  ];
}
