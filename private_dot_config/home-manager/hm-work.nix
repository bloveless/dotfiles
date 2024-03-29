{ config, fetchFromGitHub, nixpkgs, pkgs, ... }: {
  home.packages = [
    pkgs.chezmoi
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
    pkgs.btop
    (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]) # bayer p360-genomics
    pkgs.nodejs_18 # bayer p360
    pkgs.go # bayer p360-genomics
    pkgs.yq # bayer p360-genomics
    pkgs.vault # bayer p360-genomics
    pkgs.hub # bayer p360
    pkgs.gh # bayer p360
    pkgs.kubectl # bayer p360
    pkgs.kubectx # bayer p360
    pkgs.kubernetes-helm # bayer p360
    pkgs.k9s # bayer p360
  ];

  programs.git = {
    userEmail = "brennon.loveless.ext@bayer.com";
    extraConfig = {
      url = {
        "ssh://git@github.com/" = {
	  insteadOf = [
	    "https://github.com/"
	  ];
	};
      };
    };
  };

  programs.zsh = {
    enable = true;
    profileExtra = ''
      ssh-add --apple-load-keychain > /dev/null 2>&1

      export VAULT_ADDR="https://vault.agro.services"
      export HOMEBREW_GITHUB_TOKEN=$(cat $HOME/.secrets/hub-github-token)
      export GITHUB_TOKEN=$(cat $HOME/.secrets/hub-github-token)
      export GONOPROXY="github.platforms.engineering,github.com/bayer-int"
      export GONOSUMDB="github.platforms.engineering,github.com/bayer-int"
      export GOPRIVATE="github.platforms.engineering,github.com/bayer-int"

      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Environment variables necessary for development in p360 apps
      export ARCHITECTURE="arm64"
      export PLATFORM="linux/$ARCHITECTURE"
      export CWID="EJVZX"
      export GENOMICS_ROOT="$HOME/Projects/p360-genomics"
      # .rd is for rancher desktop
      export PATH="$PATH:$GENOMICS_ROOT/scripts:$GENOMICS_ROOT/cloudbuild/stages:$HOME/.rd/bin"
    '';
  };
}
