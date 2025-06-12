# IDEAS:
# 1. Detect if we are leaving a known subshell virtual environment like venv python
# 2 . Use /proc/{$fish_pid,ppid}/environ to make an env diff
function _on_exit_nested_shell --on-event fish_exit
    # If SHLVL -eq 1 then exiting the shell, will in most cases mean that the
    # terminal emulator running the shell will close the pane/tab/window the shell was running in,
    # and any output printed to stdout/stderr will not have time to be rendered/visible for the
    # human user.
    test $SHLVL -gt 1; or return
    # INVARIANT: This function is called just before the current fish process terminates
    # so /proc/$fish_pid exists for the entire duration of this call.
    echo fish_pid $fish_pid
    echo SHLVL $SHLVL
    echo (string split0 </proc/$fish_pid/cmdline) | fish_indent --ansi
    path resolve /proc/$fish_pid/exe
    # /proc/$fish_pid/stat
    # /proc/stat
    echo version $version
    echo status_generation $status_generation
    # TODO: print the path/name of the binary/interpreter that we are returning to

    # TODO: look up SHLVL in the ppids /proc/$ppid/environ, an find the process where its $SHLVL equals the current + 1
    # Walk ppid to root pid 1
    set -l ppid $fish_pid
    while test $ppid -ne 1 # pid 1 is init process started by the kernel, on most systems its systemd. It has no parent
        set ppid (string match --max-matches 1 --groups-only --regex '^PPid:\t(\d+)$' <?/proc/$ppid/status)
        if test -r /proc/$ppid/environ
            # FIXME: /proc/$ppid/environ is a binary file, how to read and parse
            string match --max-matches 1 --groups-only --regex 'SHLVL=(\d+)' </proc/$ppid/environ
        end
        echo "ppid=$ppid"
        # set ppid 1
    end
end
