{
    description = "My Home Manager Flake";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };
	agenix = {
	  url = "github:ryantm/agenix";
          inputs.nixpkgs.follows = "nixpkgs";
	};
    };

    outputs = {nixpkgs, home-manager, agenix, ...}:
    let
        zsh-powerlevel10k = import overlays/zsh-powerlevel10k/default.nix;
        lua-language-server = import overlays/lua-language-server/default.nix;
        goimports-reviser = import overlays/goimports-reviser/default.nix;
        overlays = [
	    agenix.overlays.default
            # Neovim nightly... probably don't enable this again until the master branch works
            # (
            #   import (let
            #     # rev = "master";
            #     rev = "c57746e2b9e3b42c0be9d9fd1d765f245c3827b7";
            #   in
            #     builtins.fetchTarball {
            #       url = "https://github.com/nix-community/neovim-nightly-overlay/archive/${rev}.tar.gz";
            #     })
            # )
            zsh-powerlevel10k
            # lua-language-server
            # goimports-reviser
        ];
    in
    {
        defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;

        homeConfigurations = {
            work = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = nixpkgs.legacyPackages.aarch64-darwin;

                modules = [
                    ./modules/base.nix
                    ./modules/neovim/default.nix
                    ./hm-work.nix
                    {
                        nixpkgs.overlays = overlays;
                        home = {
                            username = "ejvzx";
                            homeDirectory = "/Users/ejvzx";
                            stateVersion = "22.11";
                        };
                    }
		    agenix.homeManagerModules.default
                ];

                extraSpecialArgs = {
                    nixpkgs = nixpkgs;
                };
            };
            home = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = nixpkgs.legacyPackages.aarch64-darwin;

                modules = [
                    ./modules/base.nix
                    ./modules/neovim/default.nix
                    ./hm-home.nix
                    {
                        nixpkgs.overlays = overlays;
                        home = {
                            username = "brennon";
                            homeDirectory = "/Users/brennon";
                            stateVersion = "22.11";
                        };
                    }
                ];

                extraSpecialArgs = {
                    nixpkgs = nixpkgs;
                };
            };
            devbox = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = nixpkgs.legacyPackages.x86_64-linux;

                modules = [
                    ./modules/base.nix
                    ./modules/neovim/default.nix
                    ./hm-devbox.nix
                    {
                        nixpkgs.overlays = overlays;
                        home = {
                            username = "brennon";
                            homeDirectory = "/home/brennon";
                            stateVersion = "22.11";
                        };
                    }
                ];

                extraSpecialArgs = {
                    nixpkgs = nixpkgs;
                };
            };
        };
    };
}
