{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  home.packages = [
    pkgs.git
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.aws-sam-cli
    pkgs.ssm-session-manager-plugin
    pkgs.nodejs
    pkgs.yarn
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
  ];

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };
}
