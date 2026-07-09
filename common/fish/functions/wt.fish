function wt -d "Create git worktrees for one or more remote branches: wt branch1 branch2 ..."
    __git.is_repo; or begin
        echo "wt: not a git repository" >&2
        return 1
    end

    if test (count $argv) -eq 0
        echo "usage: wt <branch> [branch2 ...]" >&2
        return 1
    end

    set -l repo_root (command git rev-parse --show-toplevel)
    set -l repo_name (basename $repo_root)
    set -l base_dir (dirname $repo_root)

    command git fetch --all --prune

    for branch in $argv
        set -l dir_name (string replace -a '/' '-' $branch)
        set -l target_dir "$base_dir/$repo_name-$dir_name"

        if test -d "$target_dir"
            echo "wt: $target_dir already exists, skipping" >&2
            continue
        end

        if command git show-ref -q --verify "refs/heads/$branch"
            command git worktree add "$target_dir" "$branch"
        else if command git show-ref -q --verify "refs/remotes/origin/$branch"
            command git worktree add -b "$branch" "$target_dir" "origin/$branch"
        else
            echo "wt: branch '$branch' not found locally or on origin" >&2
            continue
        end
    end

    command git worktree list
end
