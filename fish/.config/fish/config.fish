if status is-interactive
	starship init fish | source
	# brew install zoxide
	zoxide init fish | source
	fish_add_path "/opt/homebrew/opt/libpq/bin"
	fish_add_path "/Applications/WezTerm.app/Contents/MacOS"
	fish_add_path "$(go env GOPATH)/bin"
	fish_add_path "$HOME/.local/bin"
	set -gx EDITOR nvim

	direnv hook fish | source
	atuin init fish | source

	# $HOME/.wezterm.sh | source
	# $HOME/.zshrc.local | source

	alias gpf "git push --force-with-lease --force-if-includes"
	# brew install bat
	alias cat 'bat'
	# brew install eza
	alias l 'eza'
	alias la 'eza -a'
	alias ll 'eza -lah'
	alias ls 'eza --color=auto'
	alias ghpr 'gh pr view -w'
	alias ghprc 'gh pr create -w'
	alias dps 'docker ps'
	alias k 'kubectl'
end

# [d]ocker [st]op [r]e[m]ove
function dstrm 
  echo "Stopping docker containers"
  docker stop $(docker container ls -aq)
  echo "Removing docker containers"
  docker rm $(docker container ls -aq)
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
