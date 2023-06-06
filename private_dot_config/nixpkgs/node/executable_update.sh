#!/usr/bin/env bash

nix-shell -p nodePackages.node2nix --command "node2nix -18 -i ./node-packages.json -o node-packages.nix"
