{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:
let
  extraNodePackages = import ./node/default.nix {};
in
{
  home.packages = [
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
    pkgs.terraform-ls
    pkgs.ripgrep
    pkgs.curl
    pkgs.go
    pkgs.golangci-lint
    pkgs.jq
    extraNodePackages.serverless
    pkgs.cachix
    pkgs.fd # for neovim telescope
  ];

  # home.shellAliases = {
  #   ssh = "kitty +kitten ssh";
  # };
}
