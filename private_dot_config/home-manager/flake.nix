{
    description = "My Home Manager Flake";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        # https://github.com/mitchellh/nixos-config/blob/main/flake.nix
        # I think technically you're not supposed to override the nixpkgs
        # used by neovim but recently I had failures if I didn't pin to my
        # own. We can always try to remove that anytime.
        neovim-nightly-overlay = {
          url = "github:nix-community/neovim-nightly-overlay";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, home-manager, neovim-nightly-overlay, ...}:
    let
        zsh-powerlevel10k = import overlays/zsh-powerlevel10k/default.nix;
        overlays = [
            neovim-nightly-overlay.overlay
            zsh-powerlevel10k
        ];
    in
    {
        defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;

        homeConfigurations = {
            work = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = nixpkgs.legacyPackages.x86_64-darwin;

                modules = [
                    ./modules/base.nix
                    ./hm-work.nix
                    {
                        nixpkgs.overlays = overlays;
                        home = {
                            username = "bloveless";
                            homeDirectory = "/Users/bloveless";
                            stateVersion = "22.11";
                        };
                    }
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
