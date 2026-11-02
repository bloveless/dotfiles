# Full compinit (rescan + audit) at most once a day; otherwise trust the dump.
autoload -Uz compinit
() { setopt local_options extended_glob; if [[ -n ~/.zcompdump(#qN.mh+24) || ! -f ~/.zcompdump ]]; then compinit; touch ~/.zcompdump; else compinit -C; fi }

# Cache `<tool> <args>` init output; key includes the Cellar version dir so `brew upgrade` regenerates it.
_cached_init() {
  local bin=${commands[$1]:A}
  [[ -n $bin ]] || return
  local f=~/.cache/zsh-init/$1-${bin:h:h:t}.zsh
  if [[ ! -s $f ]]; then
    mkdir -p ${f:h}; rm -f ${f:h}/$1-*.zsh(N)
    "$@" >| $f 2>/dev/null
  fi
  source $f
}

export EDITOR=nvim

# EDITOR contains "vi", which would otherwise make zsh default to the vi keymap
bindkey -e

source $HOME/.wezterm.sh
source $HOME/.zshrc.local

alias resetnvim="rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim"

export GPG_TTY=$TTY

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

# brew install zsh-autosuggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# brew install zsh-syntax-highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# brew install zoxide
_cached_init zoxide init zsh
# brew install starship
_cached_init starship init zsh
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

_cached_init direnv hook zsh
_cached_init fzf --zsh

source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

_cached_init atuin init zsh

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

# capture output of running pid
function capture() {
    sudo dtrace -p "$1" -qn '
        syscall::write*:entry
        /pid == $target && arg0 == 1/ {
            printf("%s", copyinstr(arg1, arg2));
        }
    '
}
