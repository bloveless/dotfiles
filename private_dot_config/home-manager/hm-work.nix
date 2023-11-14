{ config, fetchFromGitHub, nixpkgs, pkgs, ... }: {
  home.packages = [
    pkgs.chezmoi
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
    pkgs.btop
    pkgs.google-cloud-sdk # bayer p360-genomics
    pkgs.go # bayer p360-genomics
    pkgs.yq # bayer p360-genomics
    pkgs.vault # bayer p360-genomics
    pkgs.hub # bayer p360
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

      # Environment variables necessary for development in p360 apps
      export ARCHITECTURE="arm64"
      export PLATFORM="linux/$ARCHITECTURE"
      export CWID="EJVZX"
      export GENOMICS_ROOT="$HOME/Projects/p360-genomics"
      export PATH="$PATH:$GENOMICS_ROOT/scripts:$GENOMICS_ROOT/cloudbuild/stages"
    '';
  };
}
