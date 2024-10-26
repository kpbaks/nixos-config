
# \e -> alt
# \a -> alt
# \c -> ctrl

# alt-b for "back"
bind \ab 'test $PWD = /; or cd ..; commandline --function repaint'

bind \cx kill-whole-line

function copy_commandline_to_clipboard
    set -l buf (commandline)
    printf '%s\n' $buf | fish_clipboard_copy
    commandline --function repaint
    # TODO: implement notification, copy alt+t approach
    # printf "copied %s%s to clipboard\n" (commandline | fish_indent --ansi) (set_color normal)
    # printf "copied commandline to clipboard\n"
end

# Copy commandline buffer to clipboard
# bind \ec 'commandline | fish_clipboard_copy; commandline --function repaint'
bind \ac copy_commandline_to_clipboard


function __select_files_and_open_in_default_app
    if test $HOME = $PWD
        return 1
    end

    set -l reset (set_color normal)

    # TODO: color some extensions and improve fzf widget
    command fd --color always | fzf --ansi --height=~50% --multi | while read f
        xdg-open $f >&2 2>/dev/null &
        disown
        # open $f
    end

    commandline --function repaint
end

bind \co __select_files_and_open_in_default_app


# bind \an 'nextd; commandline --function repaint'
# bind \ap 'prevd; commandline --function repaint'

bind -k ppage history-search-backward


# function transient_execute
#     if commandline --is-valid
#         set -g TRANSIENT 1
#         commandline --function repaint
#     else
#         set -g TRANSIENT 0
#     end
#     commandline --function execute
# end

# function enable_transience
#     bind \r transient_execute
# end

# function disable_transience
#     bind \r execute
# end

# Pressing <cr> when the commandline is empty will execute the last command

# https://github.com/fish-shell/fish-shell/issues/7797#issuecomment-792359129
# Pressing <cr> when the commandline is empty, or only contains whitespace, will clear the commandline
# bind \r 'commandline | string trim | string length -q \
#             && commandline -f execute \
#             || commandline -r ""'

function bind_enter

    # FIXME: not working as I want
    # if commandline | string match --regex --quiet "^\s*\$"
    if commandline | string trim | string length --quiet
        # The commandline is empty or only contains spaces
        # ls
        # transient_execute
    else
        # commandline --replace ""
    end
end

# bind \r 'commandline | string trim | string length --quiet \
# && transient_execute \
# || commandline -r ""'

bind \r bind_enter



# idea from: https://github.com/fish-shell/fish-shell/issues/9751#issuecomment-1526280143
# function fzf_search_history_insert --description 'Search command history, starting with an empty query. Insert an old command at the cursor. Adapted from _fzf_search_history'
#     # history merge incorporates history changes from other fish sessions
#     builtin history merge
#
#     set command_with_ts (
#         # Reference https://devhints.io/strftime to understand strftime format symbols
#         builtin history --null --show-time="%m-%d %H:%M:%S │ " |
#         _fzf_wrapper --read0 \
#             --tiebreak=index \
#             # preview current command using fish_ident in a window at the bottom 3 lines tall
#             --preview="echo -- {4..} | fish_indent --ansi" \
#             --preview-window="bottom:3:wrap" \
#             $fzf_history_opts |
#         string collect
#     )
#
#     if test $status -eq 0
#         set command_selected (string split --max 1 " │ " $command_with_ts)[2]
#         commandline --insert -- $command_selected
#     end
#
#     commandline --function repaint
#
# end
# bind \er fzf_search_history_insert

# TODO: maybe give it a better name
# TODO: Refactor to not depend on `commandline` to read buffer state, but instead
# get it passed as input. This way the lookup logic can be used in several keybinds.
function bind_alt_t
    set -l retv 0
    set -l reset (set_color normal)

    if commandline --paging-mode
        return
    end

    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
    printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
    printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.
    if not command --query tldr
        set -l tldr_url https://dbrgn.github.io/tealdeer/
        printf "%serror%s: tealdeer is not installed, see %s\n" (set_color red) $reset $tldr_url
        set retv 1
    else
        set -l tokens (commandline --current-process --tokenize)
        if test (count $tokens) -eq 0
            printf "%shint%s: this keybind, i.e. %s%s%s, only does something, if (%s%s) has one or more tokens in it ;)\n" (set_color cyan) $reset (set_color $fish_color_command) (status function) $reset (printf "commandline --current-process" | fish_indent --ansi)
            set retv 1
        else
            # defer
            set -l program $tokens[1]
            set -l subcommand
            # TODO: first check if `tldr <program> <subcommand>` is available, if not then
            # check `tldr <command>`
            if test $program = command; and test (count $tokens) -ge 2
                set program $tokens[2]
            else if contains -- $program nmcli git cargo docker podman; and test (count $tokens) -ge 2
                # For some commands like `git` tldr has dedicated pages for some of their subcommands
                set subcommand $tokens[2]

                # TODO: handle this special case in a more general way, to allow for more
                # future edge cases.
                if test $program = nmcli -a $subcommand = dev
                    set subcommand device
                end
            end

            # TODO: scrape all pages with aliases from git repo of tldr
            set -l aliases cc gcc hx helix identify "magick identify" convert "magick convert"
            for i in (seq 1 2 (count $aliases))
                if test $aliases[$i] = $program
                    set program $aliases[(math "$i + 1")]
                    printf '%snote%s: executing %s%s, as %s%s%s is an alias for %s%s%s in tldrs database\n\n' (set_color purple) $reset (printf (echo "tldr $program" | fish_indent --ansi)) $reset (set_color $fish_color_param) $aliases[$i] $reset (set_color $fish_color_param) $program $reset
                end
            end

            # TODO: handle the case where program is not in tldr's cache and print an appropriate error message.
            # TODO: ltrim-common-ws
            command tldr $program $subcommand
            set retv 0
        end
    end

    commandline --function repaint
    return $retv
end

bind \et bind_alt_t

function show_function_definition
    set -l retv 0
    set -l reset (set_color normal)

    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
    printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
    # NOTE: assumes prompt only takes up one line. could probably be checked by running `fish_prompt`
    printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.

    set -l tokens (commandline --current-process --tokenize)
    if test (count $tokens) -eq 0
        printf "%shint%s: this keybind, i.e. %s%s%s, only does something, if (%s%s) has one or more tokens in it ;)\n" (set_color cyan) $reset (set_color $fish_color_command) (status function) $reset (printf "commandline --current-process" | fish_indent --ansi)
        set retv 1
    else
        set -l program $tokens[1]
        if functions --query $program
            type $program
        else
            printf '%serror%s: %s is not a %sfish%s function\n' (set_color red) $reset $program (set_color blue) $reset
            if command --query $program
                printf '%shint%s:  %s is a command at %s%s%s\n' (set_color magenta) $reset $program (set_color cyan) (command --search $program) $reset
            else if builtin --query $program
                printf '%shint%s:  %s is a builtin %sfish%s command\n' (set_color magenta) $reset $program (set_color blue) $reset
            end
        end
        set retv 0
    end

    commandline --function repaint
    return $retv
end

bind \ef show_function_definition

function toggle_command_prefix
    # function bind_alt_c
    set -l retv 0
    set -l reset (set_color normal)

    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
    printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
    printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.
    set -l tokens (commandline --current-process --tokenize)
    if test (count $tokens) -eq 0
        printf "%shint%s: this keybind, i.e. %s%s%s, only does something, if (%s%s) has one or more tokens in it ;)\n" (set_color cyan) $reset (set_color $fish_color_command) (status function) $reset (printf "commandline --current-process" | fish_indent --ansi)
        set retv 1
    else
        # TODO: check if there is a function `functions --query` with the name
        if string match --quiet "$tokens[1]" command
            # remove it
            # TODO: handle case where process is to the right of a pipe
            commandline --current-process --replace " $tokens[2..]"
        else
            commandline --current-process --replace "command $tokens"
            # prepend it
        end
    end

    commandline --function repaint
    return $retv
end

# Use alt+^, since nushell uses "^" as its command prefix, and alt+c is already taken (see above)
bind \e^ toggle_command_prefix

bind \er 'repos cd; commandline --function repaint'


function ctrl-d
    if commandline | string match --regex --quiet "^\s*\$"
        # I find it annoying when i press "ctrl-d" and the shell is not exited
        # because its filled with 1 or more whitespace. Just let me exit if
        # the commandline buffer is empty or only contains whitespace
        exit
    end
end

bind \cd ctrl-d

bind \cq exit

# function backspace
#     set -l buf (commandline)
#     set -l cursor (commandline --cursor)
#     if set --query autopair_pairs
#         # jorgebucaran/autopair.fish is installed
#         # Snippet below is taken from the function `_autopair_backspace`
#         test $cursor -ge 1
#         and contains -- (string sub --start=$cursor --length=2 -- "$buf") $autopair_pairs
#         and commandline --function delete-char
#     end
#     # TODO: empty buffer if it only contains whitespace
#     if test (string length "$buf") -eq 0
#         # If buffer is empty then switch to previous dir `cd -`
#         # Using $__fish_cd_direction was taken from the source code of the `cd` builtin
#         switch $__fish_cd_direction
#             case next
#                 nextd
#             case prev
#                 prevd
#         end
#         commandline --function repaint
#     else
#         commandline --function backward-delete-char
#     end
# end

# bind --key backspace backspace

function new-window
    if set --query ALACRITTY_WINDOW_ID
        command alacritty msg create-window --working-directory $PWD
    else if set --query KITTY_PID
        # TODO: this does not work
        # set -l shlvl (math $SHLVL - 1)
        # SHLVL=$shlvl command kitty --detach --working-directory $PWD
        command kitty --detach --working-directory $PWD
    end
end

bind \en new-window


function yank-commandline
    set -l buf (commandline)

    if string match --regex '^\s*$' -- $buf
        return 1
    end

    # TODO: if some text is selected then only yank that

    # TODO: select all text and then unselect, to highlight the selection like nvim

    # TODO: maybe strip final \n from $buf to make it easier to paste in a readline buffer

    printf '%s\n' $buf | fish_clipboard_copy
    # echo $buf | fish_clipboard_copy
    # echo $buf | fish_clipboard_copy
    commandline --function repaint
    # TODO: add a appropriate icon with --icon
    notify-send -t 2000 fish 'copied commandline to the clipboard'
end

bind \ey yank-commandline


function super-tab
    # If we are in paging mode, then tab should advance to the next suggestion
    # like in most text editors.
    commandline --paging-mode && down-or-search && return

    # FIXME: add a pr to detect when an autosuggestion is visible tir 10 sep 11:15:44 CEST 2024
    # commandline -f accept-autosuggestion && return

    set -l buf (commandline)
    if string match -q -r '^\s*$' -- $buf; and functions -q repos
        # Commandline is empty
        repos cd
    else
        # Commandline is not empty
        commandline -f complete
        commandline -f pager-toggle-search
    end

    commandline -f repaint
end

bind \t super-tab

function super-btab
    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
    printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
    printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.
    echo "todo, i do not have a good idea yet"
    commandline -f repaint
end

bind --key btab super-btab

function super-backspace
    commandline --paging-mode; and return

    set -l buf (commandline)
    # pwd
    # if string match -q -r '^\s*$' -- $buf
    if string match -q -r '^$' -- $buf
        # block --local
        # pwd
        if not cd -
            # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
            printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
            printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.
            printf '%serror%s: no dirs visited this session, is this a new shell?\n' (set_color red) (set_color normal) >&2
        end
    else
        commandline -f backward-delete-char
    end
    commandline -f repaint
end

# bind --key backspace super-backspace


function super-ctrl-p
    echo "todo ctrl-p like in text editors"
    commandline -f repaint
end

bind \cP super-ctrl-p

# TODO: document what this does
function super-ctrl-e
    set -q __ctrl_e_pids; or set -g __ctrl_e_pids
    # echo "todo open file manager"
    xdg-open . >&2 2>/dev/null &
    set -a __ctrl_e_pids $last_pid
    disown
    commandline -f repaint
end

bind \ce super-ctrl-e


# TODO: turn into a plugin e.g. help.fish
# TODO: add universal var to control if `<builtin> --help` should be executed or `xdg-open https://fishshell.com/docs/current/cmds/<builtin>.html`
function show_help
    set -l retv 0
    set -l reset (set_color normal)

    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
    printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
    # NOTE: assumes prompt only takes up one line. could probably be checked by running `fish_prompt`
    printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.

    set -l tokens (commandline --current-process --tokenize)
    if test (count $tokens) -eq 0
        printf "%shint%s: this keybind, i.e. %s%s%s, only does something, if (%s%s) has one or more tokens in it ;)\n" (set_color cyan) $reset (set_color $fish_color_command) (status function) $reset (printf "commandline --current-process" | fish_indent --ansi) $reset
        set retv 1
    else
        set -l program $tokens[1]
        if functions --query $program
            type $program
        else
            printf '%serror%s: %s is not a %sfish%s function\n' (set_color red) $reset $program (set_color blue) $reset
            if command --query $program
                printf '%shint%s:  %s is a command at %s%s%s\n' (set_color magenta) $reset $program (set_color cyan) (command --search $program) $reset
            else if builtin --query $program
                printf '%shint%s:  %s is a builtin %sfish%s command\n' (set_color magenta) $reset $program (set_color blue) $reset
            end
        end
        set retv 0
    end

    echo todo
    commandline --function repaint

    return $retv
end

bind \eh show_help



function __bind_new_tab
    if test -z $argv
        set -l cmdline (string split0 < /proc/$fish_pid/cmdline)
        set -l exe (path resolve /proc/$fish_pid/exe)
        if test (path basename $cmdline[1]) = fish
            # Want to use the exact same fish binary. In case the user is working on the `fish-shell` code base
            # and starting fish like `./target/{debug,release}/fish`
            set cmdline[1] $exe
            set argv $cmdline
        end
    end

    if set -q ZELLIJ; and command -q zellij
        # TODO: find a way to create a temp layout with the same args and binary as the running fish process
        command zellij action new-tab --cwd=$PWD --layout=default

    else if set -q TMUX; and command -q tmux
        command tmux new-window -c $PWD $argv

    else if set -q KITTY_PID; and command -q kitty
        kitten @ launch --type=tab --cwd=$PWD $argv

    else if set -q ALACRITTY_WINDOW_ID; and command -q alacritty
        set -l icon Alacritty
        command -q notify-send; and notify-send --icon=$icon fish "Sorry, alacritty does not support tabs"

    else if set -q KONSOLE_VERSION; and command -q konsole
        command konsole --new-tab --workdir $PWD -e $argv

    else
        set -l supported_terminals zellij tmux kitty konsole
        set -l message "The fish process: $fish_pid is not running in a compatible terminal, to spawn a new tab\nSupported termials are:\n$(printf '- %s\n' $supported_terminals)"
        command -q notify-send; and notify-send --urgency=normal --icon error fish $message
    end

    commandline --function repaint
end

bind \ct __bind_new_tab

function __bind_close_tab
    # TODO: detect if any `jobs` are running

end

function __bind_close_window
end

function __bind_new_window
    # TODO: refactor into a function to use across "new tab" "new window" "new vsplit" "new nsplit"
    if test -z $argv
        set -l cmdline (string split0 < /proc/$fish_pid/cmdline)
        set -l exe (path resolve /proc/$fish_pid/exe)
        if test (path basename $cmdline[1]) = fish
            # Want to use the exact same fish binary. In case the user is working on the `fish-shell` code base
            # and starting fish like `./target/{debug,release}/fish`
            set cmdline[1] $exe
            set argv $cmdline
        end
    end

    if set -q KITTY_PID; and command -q kitty
        # FIXME: triggers an infinite loop of spawning kitty windows
        set -l kitten_launch_opts --cwd=$PWD --type=os-window \
            --allow-remote-control \
            --copy-cmdline \
            --copy-colors \
            --copy-env \
            --stdin-source=@screen \
            --stdin-add-formatting \
            --stdin-add-line-wrap-markers


        # --remote-control-password
        # set -l remove_control_passwd (uuidgen)

        # set -l kitty_id (kitten @ launch $kitten_launch_opts $argv)
        set -l kitty_id (kitten @ launch --type=os-window --cwd=$PWD $argv)
        # IDEA: If the commandline buffer is not empty, then copy the content over into the new window.
        # IDEA: If possible also see if we can get fish to move the cursor to the current position
        set -l buf (commandline)
        if not string match --regex --quiet '^\s*$' -- $buf
            set -l cursor (commandline --cursor)
        end

    else if set -q ALACRITTY_WINDOW_ID; and command -q alacritty
        command alacritty --command $argv

    else if set -q KONSOLE_VERSION; and command -q konsole
        command konsole --new-tab --workdir $PWD $argv

    else
        set -l supported_terminals kitty alacritty konsole
        set -l message "The fish process: $fish_pid is not running in a compatible terminal, to spawn a new window\nSupported termials are:\n$(printf '- %s\n' $supported_terminals)"
        command -q notify-send; and notify-send --urgency=normal --icon error fish $message
    end

    commandline --function repaint
end

bind \cn __bind_new_window


function __bind_split_horizontal
    if set -q ZELLIJ; and command -q zellij
        command zellij action new-tab --cwd=$PWD --layout=default
    else if set -q TMUX; and command -q tmux
        command tmux new-window -c $PWD
    else if set -q KITTY_PID; and command -q kitty
        kitten @ launch --type=tab --cwd=$PWD
    else if set -q ALACRITTY_WINDOW_ID; and command -q alacritty
        set -l icon Alacritty
        notify-send --icon=$icon fish "Sorry, alacritty does not support tabs"
    else if set -q KONSOLE_VERSION; and command -q konsole
        command konsole --new-tab --workdir $PWD
    else

    end
end

function __bind_ctrl_n -d "Open a new OS window instance of the terminal emulator. Similar to ctrl-n in a browser"
    if set -z $argv
        # NOTE: this assumes Linux, I think
        # If no program is defined, use the same fish binary as the one we are running in.
        set argv (path resolve /proc/$fish_pid/exe)
    end

    if set -q KITTY_PID; and command -q kitty
        kitten @ launch --type=os-window $argv
    else if set -q ALACRITTY_WINDOW_ID; and command -q alacritty
        alacritty --working-directory $PWD --command $argv
    else
        return 1
    end
end

function __bind_ctrl_p
    if string match --regex --quiet '^\s*$' -- (commandline)
        set -l icon
        if set -q KITTY_PID; and command -q kitty
            set -l window_id (kitten @ launch --type=os-window $argv)
            kitten @ set-colors --match id:$window_id background='#25023E'
            set icon kitty
        end

        notify-send --icon=$icon fish "Opened new terminal window in `fish --private` mode. History is not persisted."
        # Commandline is empty
        # if __bind_ctrl_n fish --private
        #     # TODO: if alacritty use --config-file to use a patched config file where the background is red or purple
        #     # TODO: do the same with kitty
        # end
    else
        # TODO: create some kind of ctrl-p widget to select files
    end
end

# TODO: implement
function __bind_escape
    if commandline --search-mode
        commandline --function cancel
    else if commandline --paging-mode
        commandline --function cancel
    else if commandline --paging-full-mode
        commandline --function cancel
    end

    commandline --function end-selection
    commandline --function repaint-mode
end

# TODO: put into a plugin
# This function is automatically executed by fish when the shell is started.
function fish_user_key_bindings
    # press ctrl+y (just like vim) to accept the autosuggestion and execute the command
    # similar to pressing <right arrow> and then <enter>
    # bind \cy accept-autosuggestion and execute
    bind \cy accept-autosuggestion execute
    # TODO: cut content to clipboard
    bind \cx kill-whole-line
    # bind \cX beginning-of-buffer begin-selection end-of-buffer kill-selection

    bind \ca beginning-of-buffer begin-selection end-of-buffer
    # bind --key sr up-or-search # `sr` is shift+up
    # bind --key sf down-or-search # `sf` is shift+down

    bind \e end-selection or cancel repaint-mode # `\e` is escape
    bind \e __bind_escape

    bind :q 'gum confirm "Exit fish?" --default=yes; and exit; or commandline --function repaint'
    bind :e edit_command_buffer

    # bind --mode select --key sleft begin-selection backward-word
    # bind --mode select --key sright begin-selection forward-word
    bind --preset --key sleft begin-selection backward-word
    bind --preset --key sright begin-selection forward-word
    bind --preset --key shome begin-selection beginning-of-line
    bind --preset --key send begin-selection end-of-line

    bind --preset \cj down-or-search
    bind --preset \ck up-or-search

    # bind --preset \cc cancel-commandline and repaint

    # bind --preset \e\[D 

    # bind --mode select

    # bind -s --preset u undo
    # bind -s --preset \cr redo

    # bind -s --preset [ history-token-search-backward
    # bind -s --preset ] history-token-search-forward
    # bind -s --preset -m insert / history-pager repaint-mode
    # TODO: bind ctrl-home to `beginning-of-buffer`

    # bind --key backspace kill-selection and end-selection or backward-delete-char
    # bind --key backspace kill-selection or backward-delete-char
    # bind --key dc kill-selection or delete-char # `dc` is delete

    # bind a kill-selection or self-insert
    # set -l keys a b c d e f g h i j k l m n o p q r s t u v x y z
    # for k in $keys
    #     bind $k kill-selection or self-insert
    # end

    # bind \et 'echo todo'

    # bind \cr history-pager

    function __bind_ctrl_up
        # IDEA: if commandline not empty, then take the arguments of $history[1] and append it to the command in the buffer
        # IDEA: combine pipes together. if commandline is empty expand to "$history[1] | "
        # now if the user presses again with the cursor at "$history | <|>"
        # expand to "$history[1] | $history[2] | <|>"
        set -l buf (commandline)
        if test (commandline | string trim) = ""
            commandline --insert "$history[1] | "
            commandline --function end-of-line
        end
    end
    bind \e\[1\;5A __bind_ctrl_up # ctrl-up
    function __bind_ctrl_down
        # I do not have a good idea for this yet
        # Maybe remove a pipe to do inverse of `__bind_ctrl_up`
    end
    bind \e\[1\;5B __bind_ctrl_down # ctrl-down

    bind --key snext 'echo todo' # `snext` is shift-pagedown
    bind --key sprevious 'echo todo' # `sprevious` is shift-pageup

    function __notify_unbound_keybind -a keycode name
        if command -q notify-send
            set -l icon application-x-shellscript
            set -l body "
                keybind <b>$name</b> is not bound to anything.
                Its keybode is <b>$keycode</b>.
                Use `bind $keycode 'echo $name'` to bind it.
            "
            command notify-send --icon $icon fish $body
        else
            # TODO: print to terminal, in case user is not in graphical environment (e.g. over a ssh connection) or does not have `notify-send` installed
        end
    end

    # FIXME: figure out how to quote keycode properly, for bind to regocnize it, as if given the literal string itself
    set -l unused_keybindings \
        '\e\[121\;6u' ctrl-shift-y

    for i in (seq 1 2 (count $unused_keybindings))
        set -l keycode $unused_keybindings[$i]
        set -l keyname $unused_keybindings[(math "$i + 1")]

        bind $keycode "__notify_unbound_keybind $keycode $keyname"
    end

    # bind \e\[121\;6u 'do something'
    # bind

    bind \ct __bind_new_tab
    # bind \cn __bind_ctrl_n
    # bind \cp __bind_ctrl_p

    bind \cl 'clear; commandline --function repaint'

    bind --preset \e\[C forward-word # `\e\[C` is right arrow
    bind --preset \e\[F end-of-line # `\e\[F` is end

    bind \e\[5\;5~ '' # ctrl-pageup
    bind \e\[6\;5~ '' # ctrl-pagedown
    bind \e\[5\;3~ '' # alt-pageup
    bind \e\[6\;3~ '' # alt-pagedown

    # commandline --selection-start
    # commandline --selection-end

    # bind \e, "$EDITOR $__fish_config_dir/config.fish; commandline -f repaint"
    bind \e, "__edit_config; commandline -f repaint"
end

function __edit_config_and_source_modified_files
    block --local
    pushd $__fish_config_dir
    set -l mtime_db
    set -l mtimes_before
    set -l files_before
    path filter -f config.fish conf.d/*.fish \
        | while read f
        # set -a mtime_db $f (path mtime $f)
        set -a mtimes_before (path mtime $f)
        set -a files_before $f
    end

    $EDITOR config.fish

    set -l mtimes_after
    set -l files_after
    path filter -f config.fish conf.d/*.fish \
        | while read f
        # set -a mtime_db $f (path mtime $f)
        set -a mtimes_after (path mtime $f)
        set -a files_after $f
    end


    # TODO: check if any relevant files have been modified, and
    # `source` them again
    popd
end


function fish_in_quote -d "Test if the commandline cursor is within a quoted string"

end

function fish_in_comment -d "Test if the commandline cursor is within a line comment"

end

function __bind_resolve_absolute_path_to_binary
    # TODO: do it for all programs in the job/pipeline
    set -l tokens (commandline --tokenize  --current-process)
    # set -l tokens (commandline --tokenize --current-job)

    # notify-send fish "
    #     tokens:
    #     $tokens
    #     n: $(count $tokens)
    # "

    # return

    # echo "tokens: $tokens"
    set -l program $tokens[1]
    # echo "program: $program"
    if test -z $program
        # TODO: print helpful error message
        return
    end
    set -l args $tokens[2..]

    set -l line (commandline --line)
    set -l cursor (commandline --cursor)
    command -q $program; and not test -f $program; or return
    # echo "is binary"

    # TODO: if already expanded then, toggle back to  
    # echo hehe
    set -l absolute (path resolve (command --search $program))
    commandline --function kill-word
    commandline --function kill-line
    commandline --insert $absolute $tokens[2..]
end


bind \ea __bind_resolve_absolute_path_to_binary

# type __fish_preview_current_file

function __fish_preview_current_file
    # 1.
    # Detect file under cursor, or nearest to cursor if say at the very
    # end and there is some whitespace between it
    # OR: parse out all tokens that are files and preview each, or the one closest to
    # the cursor
    # TODO: figure out how to handle files with spaces in them robustly

    set -l cursor (commandline --cursor)
    set -l token (commandline --current-token)

    # 2.
    # Based on the mime type, call an appropriate handler
    # - if text then bat
    # - if and image file either kitten icat or timg
    # - if an audio file then start a media player
    #   - Detect the length of the audio file, if it is shorter than say 4 seconds
    #     then start mpv with a flag to say no guioutline of the
    # - if it is an pdf then use timg to only show the first page
    # - if it is a video or gif then open a image viewer like mpv or vlc
    set -l f ...
    command file --mime-type


    commandline --function repaint
end


bind \eo __bind_preview_current_file


# TODO: some keybind to detach the current kitty window into a new os-window



# TODO: bind to show `complete <command>`
# bind \eC

function __bind_alt_h
    set -l buf (commandline)
    if string match --regex --quiet '^\s*$' -- $buf
        return
    end

    history search --show-time $buf | fish_indent --ansi
end

bind \eh '__bind_alt_h; commandline --function repaint'
