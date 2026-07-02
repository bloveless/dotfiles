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

alias dlogs="docker logs -f "

alias dps="docker ps -a"
alias gpf="git push --force-with-lease --force-if-includes"
# brew install bat
alias cat='bat'
alias l='eza'
alias la='eza -a'
alias ll='eza -lah'
alias ls='eza --color=auto'
alias ghpr='gh pr view -w'
alias ghprc='gh pr create -w'
alias tf='terraform'

export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
export PATH="$PATH:$HOME/.local/bin"

# brew install zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# brew install zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# brew install zoxide
eval "$(zoxide init zsh)"
# brew install starship
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

eval "$(direnv hook zsh)"
source <(fzf --zsh)

source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

eval "$(mise activate zsh)"
eval "$(atuin init zsh)"

# Ensure the edit-command-line widget is available
autoload -U +X edit-command-line
zle -N edit-command-line

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
