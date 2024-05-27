#!/usr/bin/env nix-shell
#! nix-shell -i fish -p git

# gum choose 1 2 3

set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

function run
    echo $argv | fish_indent --ansi
    eval $argv
end


function run_or_exit
    echo $argv | fish_indent --ansi
    if not eval $argv
        set -l last_status $status
        printf '%serror%s: failed to run previous command, exit code: %d\n' (set_color red) (set_color normal) $last_status >&2
        exit $last_status
    end
end

# needed for `,` program and `program-not-found` database
run nix run nixpkgs#nix-index

# home-manager https://github.com/nix-community/home-manager/archive/master.tar.gz
# nixos https://nixos.org/channels/nixos-unstable

set -l home_manager_channel_added 0
set -l nixos_channel_is_on_unstable 0

nix-channel --list | while read channel url
    switch $channel
        case home-manager
            set home_manager_channel_added 1
        case nixos
            if test $url = https://nixos.org/channels/nixos-unstable
                set nixos_channel_is_on_unstable 1
            end
    end
end

if test $home_manager_channel_added -eq 0
    printf '%swarn%s: home-manager channel not added\n' (set_color yellow) (set_color normal) >&2
    run nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
end

if test $nixos_channel_is_on_unstable -eq 0
end

printf '%sinfo%s: updating nix channels ...\n' (set_color green) (set_color normal) >&2
run nix-channel --update

if not command --query home-manager
    printf '%swarn%s: home-manager not installed\n' (set_color yellow) (set_color normal) >&2
    run nix-shell '<home-manager>' -A install
    and run home-manager --version
end
