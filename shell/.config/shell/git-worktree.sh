# Shared shell functions: sourced by both ~/.zshrc and ~/.bashrc.
# Keep this file bash- and zsh-compatible.

# Clones a repository into a layout built for worktrees:
#
#   <dir>/
#   ├── .bare/   bare repository (all git data)
#   ├── .git     file containing "gitdir: ./.bare" so git works from <dir>/
#   └── main/    worktree for the default branch
#
# Run `git worktree add ...` from <dir>/ and worktrees land next to main/,
# e.g. `git worktree add -b bloveless/foo bloveless/foo origin/main`.
#
# Bare clones skip several things a normal clone sets up, so this restores them:
#   - fetch refspec, so origin/* remote-tracking branches exist
#   - origin/HEAD and upstream tracking for the default branch
#   - removes the stale local copies of every remote branch that --bare creates,
#     so `git worktree add <path> <branch>` checks out the remote branch with tracking
# And sets per-repo push behavior so new branches push to origin with a plain `git push`:
#   - push.autoSetupRemote: first push creates origin/<branch> and sets upstream
#   - branch.autoSetupMerge=simple: a branch created from origin/main does NOT
#     track origin/main (which would make `git push` refuse)
git-clone-worktree() {
    if [[ -z "$1" ]]; then
        echo "Usage: git-clone-worktree <repo_url> [directory_name]" >&2
        return 1
    fi

    local repo_url="$1"
    local dir_name="${2:-$(basename "$repo_url" .git)}"

    if [[ -e "$dir_name" && -n "$(ls -A "$dir_name" 2>/dev/null)" ]]; then
        echo "Error: '$dir_name' already exists and is not empty." >&2
        return 1
    fi

    mkdir -p "$dir_name" && cd "$dir_name" || return 1

    echo "Cloning bare repository into .bare/..."
    git clone --bare "$repo_url" .bare || return 1
    echo "gitdir: ./.bare" > .git

    # A bare clone's HEAD points at the remote's default branch
    local default_branch
    default_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    default_branch="${default_branch:-main}"

    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git config push.autoSetupRemote true
    git config branch.autoSetupMerge simple
    git config worktree.useRelativePaths true   # needs git >= 2.48; ignored on older git

    echo "Fetching remote-tracking branches..."
    git fetch --prune origin || return 1
    git remote set-head origin "$default_branch" >/dev/null

    # Drop the local branch copies --bare made; they would shadow origin/* without tracking
    git for-each-ref --format='%(refname:short)' refs/heads \
        | grep -vxF "$default_branch" \
        | while read -r b; do git branch -D -q "$b"; done
    git branch --set-upstream-to="origin/$default_branch" "$default_branch" >/dev/null

    echo "Creating worktree for '$default_branch'..."
    git worktree add "$default_branch" "$default_branch" || return 1

    echo "Done: $(pwd)"
    git worktree list
}
