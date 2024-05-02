#!/usr/bin/env nix-shell
#! nix-shell -i fish -p gum git difftastic

set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

set -l scriptdir (status filename | path dirname | path resolve)

set -l options h/help v/verbose y/yes n/dry-run

if not argparse $options -- $argv
    return 2
end

if test $scriptdir != $PWD
    printf '%swarn:%s script was not called from %s\n' $yellow $reset $scriptdir
end

pushd $scriptdir

source ./utils.fish


# 1. check if ./configuration.nix has any changes since its latest commit
# - if it does not, then print a message and quit.
set -l modified_files (git ls-files --modified)
if not contains -- configuration.nix $modified_files
    set -l current_branch main
    set -l last_commit_hash (git rev-parse --short --verify $current_branch)
    printf '%serror%s: ./configuration.nix contains to modifications since last commit: %s%s%s\n' $red $reset $yellow $latest_commit_hash $reset
    exit 1
end

# 2. show changes
git --no-pager diff ./configuration.nix

if not gum confirm "make derivation?" --default=true
    exit 0
end

# set -l euid (id --user)

# if test $euid -ne 0
#     exit 2
# end

if set --query _flag_dry_run
    exit 0
end

if sudo nixos-rebuild switch --flake .
    # FIXME: does not give the correct generation
    set -l generation (nix-env --list-generations | tail -1 | string match --regex --groups-only '^\s+(\d+)')
    set -l message "feat(system): derived generation $generation"
    gum confirm "stage ./configuration.nix and commit with message: '$message'?" --default=true
    and git add ./configuration.nix
    and git commit --edit --message $message
    and git log -1 HEAD

    gum confirm "push to remote: $remote?" --default=true
    and git push
end

# nixos-rebuild
# nixos-rebuild switch --flake .#
# nixos-rebuild switch --flake .

popd $scriptdir
