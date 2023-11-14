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
    '';
  };
}
