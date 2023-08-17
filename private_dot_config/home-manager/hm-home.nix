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
    pkgs.btop
    pkgs.temurin-jre-bin-18 # for dynamobd local
  ];

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };

  programs.zsh = {
    enable = true;
    profileExtra = ''
      test -d "$HOME/.tea" && source <("$HOME/.tea/tea.xyz/v*/bin/tea" --magic=zsh --silent)
      export PATH="$PATH:$HOME/.npm-global"
    '';
  };
}
