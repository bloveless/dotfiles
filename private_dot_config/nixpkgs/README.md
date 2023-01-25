# Home Manager

To update home-manager from the flake run the following command from within the ~/.config/nixpkgs directory

```
nix run . switch -- --flake . --impure
```

`nix run . switch` is short for `home-manager switch` later. `--` helps it understand which flags are for nix run vs to pass into home-manager switch. (See reference #1)

Impure here is required so the the non free packages can be included.

Home manager can then be run normally with `home-manager switch --impure`.

## Resources

1. https://www.chrisportela.com/posts/home-manager-flake/

