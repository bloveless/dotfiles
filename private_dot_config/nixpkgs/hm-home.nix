{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:

{
  home.packages = [
    pkgs.git
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.k9s
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
    pkgs.rustup
    pkgs.cargo-lambda
  ];

  # home.shellAliases = {
  #   ssh = "kitty +kitten ssh";
  # };
}
