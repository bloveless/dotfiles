{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:
{
  home.packages = [
    pkgs.git
    pkgs.chezmoi
    pkgs.k9s
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
