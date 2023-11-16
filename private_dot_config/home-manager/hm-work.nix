{ config, fetchFromGitHub, nixpkgs, pkgs, ... }: {
  home.packages = [
    pkgs.chezmoi
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
    pkgs.btop
    pkgs.sops
    (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]) # bayer p360-genomics
    pkgs.nodejs_18 # bayer p360
    pkgs.go # bayer p360-genomics
    pkgs.yq # bayer p360-genomics
    pkgs.vault # bayer p360-genomics
    pkgs.hub # bayer p360
    pkgs.kubectl # bayer p360
    pkgs.kubectx # bayer p360
    pkgs.kubernetes-helm # bayer p360
    pkgs.k9s # bayer p360
  ];

  sops = {
    # age.keyFile = "/home/user/.age-key.txt"; # must have no password!
    # It's also possible to use a ssh key, but only when it has no password:
    age.sshKeyPaths = [ "/Users/ejvzx/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.hub_github_token = {
      # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

      # %r gets replaced with a runtime directory, use %% to specify a '%'
      # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
      # DARWIN_USER_TEMP_DIR) on darwin.
      path = "${config.home.homeDirectory}/.secrets/hub-github-token"; 
    };
  };

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
      export HOMEBREW_GITHUB_TOKEN=$(cat ${config.home.homeDirectory}/.secrets/hub-github-token)
      export GITHUB_TOKEN=$(cat ${config.home.homeDirectory}/.secrets/hub-github-token)

      # Environment variables necessary for development in p360 apps
      export ARCHITECTURE="arm64"
      export PLATFORM="linux/$ARCHITECTURE"
      export CWID="EJVZX"
      export GENOMICS_ROOT="$HOME/Projects/p360-genomics"
      export PATH="$PATH:$GENOMICS_ROOT/scripts:$GENOMICS_ROOT/cloudbuild/stages"
    '';
  };
}
