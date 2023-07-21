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
    pkgs.cachix
    pkgs.nodejs # for neovim to install language servers
    pkgs.fd # for neovim telescope
    pkgs.lazygit # for neovim git
  ];

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };
}
