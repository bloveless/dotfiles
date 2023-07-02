{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:
{
  home.packages = [
    pkgs.git
    pkgs.chezmoi
    pkgs.k9s
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
  ];

  # home.shellAliases = {
  #   ssh = "kitty +kitten ssh";
  # };
}
