final: prev: {
  goimports-reviser = prev.buildGoModule rec {
    pname = "goimports-reviser";
    version = "3.3.1";

    src = prev.fetchFromGitHub {
      owner = "incu6us";
      repo = "goimports-reviser";
      rev = "390547f35c43dcfd3fa4235527c947d98cffd2f8";
      sha256 = "sha256-JIXBC7fk/Bd3tTHiK+qtB+5CdAATaB/j1nvKOJrz4n4=";
    };

    subPackages = [ "." ];

    vendorHash = "sha256-lyV4HlpzzxYC6OZPGVdNVL2mvTFE9yHO37zZdB/ePBg=";

    meta = with prev.lib; {
      description = "Simple command-line snippet manager, written in Go";
      homepage = "https://github.com/knqyf263/pet";
      license = licenses.mit;
      maintainers = with maintainers; [ kalbasit ];
    };
  };
}
