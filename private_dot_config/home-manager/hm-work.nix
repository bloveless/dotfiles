{ config, fetchFromGitHub, nixpkgs, pkgs, ... }: {
  home.packages = [
    pkgs.git
    pkgs.chezmoi
    pkgs.groff
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
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
      test -d "$HOME/.tea" && source <("$HOME/.tea/tea.xyz/v*/bin/tea" --magic=zsh --silent)
      export PATH="$PATH:$HOME/.npm-global/bin"
    '';
  };
}
