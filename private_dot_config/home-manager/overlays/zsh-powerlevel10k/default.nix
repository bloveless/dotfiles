final: prev: {
  zsh-powerlevel10k = prev.zsh-powerlevel10k.overrideAttrs (old: {
    version = "1.19.0";

    src = prev.fetchFromGitHub {
      owner = "romkatv";
      repo = "powerlevel10k";
      rev = "refs/tags/v1.19.0";
      hash = "sha256-+hzjSbbrXr0w1rGHm6m2oZ6pfmD6UUDBfPd7uMg5l5c=";
    };
  });
}
