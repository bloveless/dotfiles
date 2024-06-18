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

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
fi

export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"
export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
