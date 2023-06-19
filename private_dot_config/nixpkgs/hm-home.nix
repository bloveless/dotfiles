{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  home.packages = [
    pkgs.git
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.k9s
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
    pkgs.helix
    pkgs.aws-sam-cli
  ];

  # home.shellAliases = {
  #   ssh = "kitty +kitten ssh";
  # };
}
