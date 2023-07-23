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
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
  ];

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };
}
