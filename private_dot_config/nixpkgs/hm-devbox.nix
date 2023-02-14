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
  ];
}
