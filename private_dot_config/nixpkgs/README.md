# Home Manager

To update home manager from the flake run the following command from within the ~/.config/nixpkgs directory

```
nix run . switch -- --flake .
```

Home manager can then be run normally with `home-manager switch`
