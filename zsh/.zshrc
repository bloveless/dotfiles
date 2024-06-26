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

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/catppuccin_frappe.omp.json)"
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/catppuccin.json)"
fi

export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"

# brew install zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# brew install zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
