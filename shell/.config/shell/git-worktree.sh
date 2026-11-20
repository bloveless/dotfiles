# Shared shell functions: sourced by both ~/.zshrc and ~/.bashrc.
# Keep this file bash- and zsh-compatible.

# Clones a repository into a layout built for worktrees:
#
#   <dir>/
#   ├── .git/    bare repository (core.bare = true, all git data)
#   └── main/    worktree for the default branch
#
# Run `git worktree add ...` from <dir>/ and worktrees land next to main/,
# e.g. `git worktree add -b bloveless/foo bloveless/foo origin/main`.
#
# Uses `git clone --no-checkout` then sets `core.bare true` so git sets up
# remote.origin.fetch, origin/HEAD, and upstream tracking for the default
# branch automatically without leaving stale local copies of other branches.
# Per-repo config ensures consistent worktree/push behavior without relying on
# global git config:
#   - push.autoSetupRemote: first push creates origin/<branch> and sets upstream
#   - branch.autoSetupMerge=simple: a branch created from origin/main does NOT
#     track origin/main (which would make `git push` refuse)
#   - worktree.useRelativePaths: keep worktree links portable (git >= 2.48)
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

    echo "Cloning repository into '$dir_name'..."
    git clone --no-checkout "$repo_url" "$dir_name" || return 1
    cd "$dir_name" || return 1

    git config core.bare true
    git config push.autoSetupRemote true
    git config branch.autoSetupMerge simple
    git config worktree.useRelativePaths true   # needs git >= 2.48; ignored on older git

    local default_branch
    default_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    default_branch="${default_branch:-main}"

    echo "Creating worktree for '$default_branch'..."
    git worktree add "$default_branch" "$default_branch" || return 1

    echo "Done: $(pwd)"
    git worktree list
}
