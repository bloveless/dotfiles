autoload -U +X compinit && compinit

export EDITOR=nvim

eval "$(/opt/homebrew/bin/brew shellenv)"
source $HOME/.wezterm.sh
source $HOME/.zshrc.local

alias resetnvim="rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim"

export GPG_TTY=$(tty)

function dstrm { # [d]ocker [st]op [r]e[m]ove
  echo "Stopping docker containers"
  docker stop $(docker container ls -aq)
  echo "Removing docker containers"
  docker rm $(docker container ls -aq)
}

alias dps="docker ps -a"
alias gpf="git push --force-with-lease --force-if-includes"
# brew install bat
alias cat='bat'
# brew install eza
alias l='eza'
alias la='eza -a'
alias ll='eza -lah'
alias ls='eza --color=auto'
alias ghpr='gh pr view -w'
alias ghprc='gh pr create -w'

export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

# brew install zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# brew install zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Bind ctry+y to zsh autosuggestions accept
bindkey '^y' autosuggest-accept

# brew install zoxide
eval "$(zoxide init zsh)"
# brew install starship
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
