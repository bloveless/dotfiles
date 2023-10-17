{ config, fetchFromGitHub, nixpkgs, pkgs, ... }:
{
  home.packages = [
    pkgs.chezmoi
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
    pkgs.btop
  ];

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };

  programs.zsh = {
    enable = true;
    profileExtra = ''
      export PATH="$PATH:$HOME/.npm-global/bin"
    '';
  };
}
