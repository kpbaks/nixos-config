#!/usr/bin/env -S fish --no-config

set -l reset (set_color normal)
set -l red (set_color red)
set -l yellow (set_color yellow)

set -l scriptdir (status filename | path dirname | path resolve)

if test $scriptdir != $PWD
    printf '%swarn:%s script was not called from %s\n' $yellow $reset $scriptdir
end

pushd $scriptdir

source ./utils.fish

set -l euid (id --user)

id

if test $euid -ne 0
    exit 2
end

# nixos-rebuild
# nixos-rebuild switch --flake .#
nixos-rebuild switch --flake .

popd $scriptdir
