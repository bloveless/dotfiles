# Static copy of `brew shellenv` output (saves a ~90ms fork per shell)
export HOMEBREW_PREFIX="/opt/homebrew" HOMEBREW_CELLAR="/opt/homebrew/Cellar" HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
export PATH="$PATH:${GOPATH:-$HOME/go}/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.bun/bin"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
