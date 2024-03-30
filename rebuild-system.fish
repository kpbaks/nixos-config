#!/usr/bin/env -S fish --no-config

set -l reset (set_color normal)
set -l bold (set_color --bold)
set -l italics (set_color --italics)
set -l red (set_color red)
set -l green (set_color green)
set -l yellow (set_color yellow)
set -l blue (set_color blue)
set -l cyan (set_color cyan)
set -l magenta (set_color magenta)

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

set -l euid (id --user)

if test $euid -ne 0
    exit 2
end

if set --query _flag_dry_run
    exit 0
end

if sudo nixos-rebuild switch

    # set -l generation (home-manager generations | head -1 | string match --groups-only --regex 'id (\d+)')
    # set -l message "feat(home): derived generation $generation"
    # gum confirm "stage ./home.fix and commit with message: '$message'?" --default=true
    # and git add ./home.nix
    # # TODO: just use `git commit` and enter commit msg in editor, but have it default to $message
    # and git commit --message $message
    # and git log -1 HEAD
end

# nixos-rebuild
# nixos-rebuild switch --flake .#
# nixos-rebuild switch --flake .

popd $scriptdir
