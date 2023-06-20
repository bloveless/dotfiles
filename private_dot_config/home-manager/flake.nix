{
    description = "My Home Manager Flake";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, home-manager, ...}: {
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