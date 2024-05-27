#!/usr/bin/env nix-shell
#! nix-shell -i fish -p gum git difftastic

set -l reset (set_color normal)
set -l bold (set_color --bold)
set -l italics (set_color --italics)
set -l red (set_color red)
set -l green (set_color green)
set -l yellow (set_color yellow)
set -l blue (set_color blue)
set -l cyan (set_color cyan)
set -l magenta (set_color magenta)

set -l options h/help v/verbose y/yes n/dry-run

if not argparse $options -- $argv
    return 2
end

set -l scriptdir (status filename | path dirname | path resolve)

if test $scriptdir != $PWD
    printf '%swarn:%s script was not called from %s\n' $yellow $reset $scriptdir
end

if set --query _flag_help
    set -l option_color (set_color $fish_color_option)
    set -l section_header_color (set_color yellow)
    printf '\n'
    printf '%sOPTIONS:%s\n' $section_header_color $reset

    printf '\t%s-h%s, %s--help%s show this help message and exit\n' $option_color $reset $option_color $reset

    return 0
end >&2



# 1. check if ./home.nix has any changes since its latest commit
# - if it does not, then print a message and quit.
set -l modified_files (git ls-files --modified)
if not contains -- home.nix $modified_files
    set -l current_branch main
    set -l last_commit_hash (git rev-parse --short --verify $current_branch)
    printf '%serror%s: ./home.nix contains to modifications since last commit: %s%s%s\n' $red $reset $yellow $latest_commit_hash $reset
    exit 1
end

# 2. show changes
git --no-pager diff ./home.nix

if not gum confirm "make derivation?" --default=true
    exit 0
end

# if not set --query _flag_yes
#     read 
# end

set -l hm_switch_opts --print-build-logs --cores '(math (nproc) - 1)'
# set -l expr gum spin --title "building derivation..." -- home-manager switch $hm_switch_opts --file ./home.nix
set -l expr home-manager switch $hm_switch_opts --file ./home.nix
# home-manager switch --flake .

if set --query _flag_verbose
    echo $expr | fish_indent --ansi
end

if set --query _flag_dry_run
    exit 0
end


# if gum spin --title "building derivation..." -- home-manager switch $hm_switch_opts --file ./home.nix
if eval $expr
    set -l generation (home-manager generations | head -1 | string match --groups-only --regex 'id (\d+)')
    set -l message "feat(home): derived generation $generation"
    gum confirm "stage ./home.nix and commit with message: '$message'?" --default=true
    and git add ./home.nix
    # TODO: just use `git commit` and enter commit msg in editor, but have it default to $message
    and git commit --edit --message $message
    and git log -1 HEAD
    and gum confirm "push to remote: $remote?" --default=true
    and git push
end

return 0
