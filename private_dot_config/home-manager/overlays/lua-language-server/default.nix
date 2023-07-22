final: prev: {
  lua-language-server = prev.lua-language-server.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ (prev.lib.optionals prev.pkgs.stdenv.isDarwin [
        prev.pkgs.darwin.ditto
    ]);
  });
}
