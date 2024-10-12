{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors =
    let
      colors = [
        "white"
        "black"
        "red"
        "green"
        "blue"
        "yellow"
        "cyan"
        "magenta"
      ];
      brcolors = map (c: "br${c}") colors;
      markup = [
        "bold"
        "dim"
        "italics"
        "underline"
        "reverse"
      ];
    in
    lib.concatLines (
      [ "set -l reset (set_color normal)" ]
      ++ (map (c: "set -l ${c} (set_color ${c})") (colors ++ brcolors))
      ++ (map (c: "set -l bg${c} (set_color --background ${c})") (colors ++ brcolors))
      ++ (map (
        m:
        let
          first-char = builtins.substring 0 1 m;
        in
        "set -l ${first-char} (set_color --${m})"
        # "set -l ${m} (set_color --${m})"
      ) markup)
    );

  prepend-colors =
    fnbody:
    lib.concatLines [
      colors
      fnbody
    ];
  cds =
    lib.pipe
      {
        c = "~/.config";
        dev = "~/development/own";
        df = "~/dotfiles";
        dl = "~/Downloads";
        d = "~/Documents";
        f = "$__fish_config_dir";
        # hx = "~/.config/helix";
        m = "~/Music";
        obs = "~/Videos/OBS";
        p = "~/Pictures";
        s = "~/.local/share";
        sc = "~/Videos/Screencasts";
        sh = "~/Pictures/screenshots";
        v = "~/Videos";
        w = "~/work";
        # z = "~/.config/zellij";
      }
      [
        (builtins.mapAttrs (k: dir: { "cd${k}" = "builtin cd ${dir}"; }))
        builtins.attrValues
        (builtins.foldl' (a: b: a // b) { })
      ];
in
{
  programs.fish.functions =
    let
      # grc = "${pkgs.grc}/bin/grc";
      grc = program: "${pkgs.grc}/bin/grc ${program} $argv";
      grcs =
        lib.pipe
          [
            "dig"
            "findmnt"
            "gcc"
            "id"
            "ping"
            "df"
            "du"
            "ps"
            "lsattr"
            "uptime"
            "mount"
            "lsmod"
            "lsblk"
            "lspci"
            "stat"
          ]
          [
            (map (fn: {
              ${fn} = grc fn;
            }))
            (builtins.foldl' (a: b: a // b) { })
          ];
    in
    cds
    // grcs
    // {
      fd = # fish
        ''
          if isatty stdout; and not contains -- --hyperlink $argv
              set --prepend argv --hyperlink
          end

          ${pkgs.fd}/bin/fd $argv
        '';
      free =
        prepend-colors
          #fish
          ''
            # Taken from: https://www.youtube.com/watch?v=Dl2n_fcDjkE
            if not status is-interactive
                ${pkgs.procps}/bin/free $argv
                return
            end

            ${pkgs.procps}/bin/free --human --si --total $argv \
                | string replace "Total:" "$(set_color --bold)Total:$(set_color normal)" \
                | string replace --regex --all "(\d+(\.\d+)?)([KMGTPEZY])" "$(set_color --bold green)\$1$(set_color normal)$(set_color green)\$3$(set_color normal)"


            set -l n (math "min 102,$COLUMNS")
            # set -l d ─
            set -l d ━
            set -l hr (string repeat --count $n $d)

            printf "%s\n" $hr

            printf "%sshared%s:     Memory used (mostly) by tmpfs (shmem / shmfs) filesystems\n" $cyan $reset
            printf "%sbuff/cache%s: Memory used by kernel buffers, plus memory used by the page cache and slabs\n" $cyan $reset
            printf "%savailable%s:  Estimation of how much memory is available for starting new applications, without swapping\n" $cyan $reset
          '';
      isp = prepend-colors ''${pkgs.curl}/bin/curl --silent ipinfo.io/org'';
      ip = # fish
        ''
          if test (count $argv) -eq 0
              set argv --color addr show
          end

          ${pkgs.iproute2}/bin/ip $argv
        '';
      ldd =
        prepend-colors
          # fish
          ''
            if not isatty stdout
                command ldd $argv
                return $status
            end

            # Prettify ldd output
            set -l shared_objects
            set -l rhs
            command ldd $argv \
                | while read so rest
                set --append shared_objects $so
                set --append rhs $rest
            end

            set -l max_so_length 0
            set -l max_abs_length 0
            for i in (seq (count $shared_objects))
                set -l so $shared_objects[$i]
                set max_so_length (math "max $max_so_length, $(string length $so)")
                if string match --regex --groups-only "=> (\S+) \((0x[0-9a-f]+)\)" $rhs[$i] | read --line abs memory_address
                    set max_abs_length (math "max $max_abs_length, $(string length $abs)")
                end
            end

            set -l hr (string repeat --count $COLUMNS "-")
            set -l column_title_shared_objects "Shared Objects"
            set -l column_title_found_at "Found on filesystem at"
            set -l column_title_memory_address "Memory address"
            set -l column_title (printf "%s %s %s %s %s\n" \
                $column_title_shared_objects \
                (string repeat --count (math "$max_so_length - $(string length $column_title_shared_objects) - 1") " ") \
                $column_title_found_at \
                (string repeat --count (math "$max_abs_length - $(string length $column_title_found_at)" - 1) " ") \
                $column_title_memory_address)

            printf "%s%s%s\n" $b $hr $reset
            printf "%s%s%s\n" $b $column_title $reset
            printf "%s%s%s\n" $b $hr $reset

            for i in (seq (count $shared_objects))
                set -l so $shared_objects[$i]
                set -l padding_length (math "$max_so_length - $(string length $so)")
                # if test $padding_length -eq 0
                #     set padding_length 1
                # end
                set padding_length (math "$padding_length + 1")
                set -l padding (string repeat --count $padding_length " ")

                if string match --regex --quiet "not found" $rhs[$i]
                    printf "%s%s%s%s%s\n" $red $so $padding $rhs[$i] $reset
                else if string match --regex --groups-only "=> (\S+) \((0x[0-9a-f]+)\)" $rhs[$i] | read --line abs memory_address
                    set -l rhs_padding_length (math "$max_abs_length - $(string length $abs)")
                    set rhs_padding_length (math "$rhs_padding_length + 1")
                    set -l rhs_padding (string repeat --count $rhs_padding_length " ")
                    printf "%s%s%s%s(%s)\n" $so $padding $abs $rhs_padding $memory_address

                else
                    set -l rhs_padding_length (math "$max_abs_length + 1")
                    set -l rhs_padding (string repeat --count $rhs_padding_length " ")
                    printf "%s%s%s%s\n" $so $padding $rhs_padding $rhs[$i]
                end

            end | string replace --regex --all "(0x[0-9a-f]+)" "$(set_color cyan)\$1$(set_color normal)" # \

            printf "%s%s%s\n" $b $hr $reset
            printf "%s%s%s\n" $b $column_title $reset
            printf "%s%s%s\n" $b $hr $reset
          '';

      nl = # fish
        ''
          if isatty stdout
              set -l reset (set_color normal)
              set -l green (set_color green)
              set -l dimgreen (set_color green --dim)

              set -l i 1
              ${pkgs.coreutils-full}/bin/nl $argv | while read -l line
                  set -l color
                  if test (math "$i % 2") -eq 0
                      set color $green
                  else
                      set color $dimgreen
                  end

                  string replace --regex '^(\s*)(\d+)' "\$1$color\$2$reset" -- $line
                  set i (math "$i + 1")
              end
          else

              ${pkgs.coreutils-full}/bin/nl $argv
          end
        '';
      ppid = {
        argumentNames = [ "pid" ];
        body =
          # fish
          ''
            if test (count $argv) -eq 0
              set pid $fish_pid
            end

            if not test -e /proc/$pid
              printf '%serror%s: invalid pid: %s, not found in under /proc/*\n' (set_color red) (set_color normal) $pid
              return 2
            end

            string match --regex --groups-only "^PPid:\s+(\d+)" </proc/$pid/status
          '';
      };
      root = # fish
        ''
          set -l dir $PWD
          while test $dir != /
            test -d $dir/.git; and break
            set dir (path dirname $dir)
          end

          test $dir = $PWD; and return
          builtin cd $dir
        '';
      rfkill = # fish
        ''
          if test (count $argv) -eq 0
            ${pkgs.util-linux}/bin/rfkill \
            | string replace --all --regex "\bblocked\b" "$(set_color red)blocked$(set_color normal)" \
            | string replace --all --regex "\bunblocked\b" "$(set_color green)unblocked$(set_color normal)"
          else
              ${pkgs.util-linux}/bin/rfkill $argv
          end
        '';
      ssh = # fish
        ''
          if set -q KITTY_PID
            kitten ssh $argv
          else
            ${pkgs.openssh}/bin/ssh $argv
          end
        '';
      __show_cursor = {
        # I have some programs like `leds` which remove the cursor. Sometimes
        # it fails to show the cursor again.
        # But with this hook it is always ensured
        body = # fish
          ''printf "\033[?25h"'';
        onEvent = "fish_prompt";
      };
      fish_colors = # fish
        '''';

      cdn = # fish
        ''
          builtin cd /etc/nixos
          $EDITOR flake.nix
        '';
    };
}

# function hl-markdown
#     set -l reset (set_color normal)
#     set -l b (set_color --bold)
#     set -l i (set_color --italics)
#     set -l u (set_color --underline)
#     set -l inline_code (set_color $fish_color_command --background '#222222')

#     if isatty stdin
#         printf '%serror%s: stdin must be a pipe, not a tty i.e. pipe text with ` | %s` or use file redirection with `%s < <file>`\n' (set_color red) $reset (status function) (status function)
#         return 2
#     else
#         command cat \
#             # inline code blocks
#             | string replace -ar '`([^`]+)`' "$inline_code \$1 $reset" \
#             # bold text
#             | string replace -ar '\*\*([^*]+)\*\*' "$b\$1$reset" \
#             # italic text
#             | string replace -ar '\*([^*]+)\*' "$i\$1$reset" \
#             # Markdown does not support underline with dedicated syntax
#             # but you can use `<u></u>` tags from html.
#             | string replace -ar '<u>([^<]+)</u>' "$u\$1$reset"
#         # TODO: convert hyperlinks to kitty hyperlinks
#         # | string replace -ar '[(\w+)]\([^)]+\)' ""
#         return 0
#     end
# end

# function __bang_open -a url
#     command xdg-open $url >&2 2>/dev/null &
#     disown
# end

# set -g __bang_gen_prefixes
# set -g __bang_gen_base_urls
# set -g __bang_gen_names

# function __bang_gen -a prefix base_url name -d "higher order function to easily create duckduckgo like !bang commands!"
#     set -a __bang_gen_prefixes $prefix
#     set -a __bang_gen_base_urls $base_url
#     set -a __bang_gen_names $name
#     eval "
#         function !$prefix -d 'equivalent to the !$prefix ($name) bang in duckduckgo'
#             __bang_open '$base_url'(string join + \$argv)
#         end
#     "
# end

# function bangs -d "list all available bangs"
#     set -l N (count $__bang_gen_prefixes)
#     set -l reset (set_color normal)
#     set -l color_command (set_color $fish_color_command)
#     set -l color_name (set_color --italics --bold)

#     set -l length_of_widest_name 0
#     for name in $__bang_gen_names
#         set length_of_widest_name (math max "$length_of_widest_name,$(string length $name)")
#     end

#     # Print tabulated with all columns aligned
#     for i in (seq $N)
#         set -l name_length (string length $__bang_gen_names[$i])
#         set -l padding (string repeat --count (math "$length_of_widest_name - $name_length + 1") " ")
#         printf "%s!%s%s\t%s%s%s%s  %s\n" \
#             $color_command $__bang_gen_prefixes[$i] $reset \
#             $color_name $__bang_gen_names[$i] $reset \
#             $padding $__bang_gen_base_urls[$i]
#     end
# end

# __bang_gen g 'https://www.google.com/search?hl=en&q=' google
# __bang_gen r 'https://www.wolframalpha.com/input?i=' reddit
# __bang_gen wa "https://www.wolframalpha.com/input?i=" wolframalpha
# __bang_gen yt "https://www.youtube.com/results?search_query=" youtube
# __bang_gen w "https://en.wikipedia.org/wiki/" wikipedia
# __bang_gen gh "https://github.com/search?utf8=yes&type=repositories&q=" github
# __bang_gen so "https://stackoverflow.com/search?q=" stackoverflow
# # __bang_gen rust "https://docs.rs/releases/search?query=" rust
# __bang_gen rs "https://docs.rs/releases/search?query=" rust
# # __bang_gen crate "https://crates.io/search?q=" crate
# __bang_gen c "https://crates.io/search?q=" crates.io
# __bang_gen std "https://doc.rust-lang.org/std/?search=" rust-std
# __bang_gen docs "https://docs.rs/" docs.rs

# # !rust -> https://docs.rs/releases/search?query=%s
# # !!rust -> https://docs.rs/%s
# # !crate -> https://crates.io/search?q=%s
# # !!crate -> https://crates.io/crates/%s
# # !std -> https://doc.rust-lang.org/std/?search=%s

# # TODO: turn into plugin `cdgen.fish`
# function cd-generator -a char dir -d "Higher order function/macro to generate cd. like functions"
#     if not argparse --min-args 2 --max-args 2 -- $argv
#         return 2
#     end
#     eval "function cd$char -d 'cd to $dir'
#     if not test -d $dir
#         printf '%serror:%s directory %s%s%s does not exist!\n' (set_color red) (set_color normal) (set_color --bold) ~/Pictures (set_color normal) >&2
#         return 1
#     end

#     cd $dir
# end
#     "
# end

# function fish_colors -d "print each `fish_(pager_)?color_*` variable with their respective color"
#     set -l reset (set_color normal)

#     # https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables

#     set -l syntax_highlighting_variables \
#         fish_color_normal 0 \
#         fish_color_command 0 \
#         fish_color_keyword 0 \
#         fish_color_quote 0 \
#         fish_color_redirection 0 \
#         fish_color_end 0 \
#         fish_color_error 0 \
#         fish_color_param 0 \
#         fish_color_valid_path 0 \
#         fish_color_option 0 \
#         fish_color_comment 0 \
#         fish_color_selection 0 \
#         fish_color_operator 0 \
#         fish_color_escape 0 \
#         fish_color_autosuggestion 0 \
#         fish_color_cwd 0 \
#         fish_color_cwd_root 0 \
#         fish_color_user 0 \
#         fish_color_host 0 \
#         fish_color_host_remote 0 \
#         fish_color_status 0 \
#         fish_color_cancel 0 \
#         fish_color_search_match 0 \
#         fish_color_history_current 0

#     # https://fishshell.com/docs/current/interactive.html#pager-color-variables
#     set -l pager_color_variables \
#         fish_pager_color_progress 0 \
#         fish_pager_color_background 0 \
#         fish_pager_color_prefix 0 \
#         fish_pager_color_completion 0 \
#         fish_pager_color_description 0 \
#         fish_pager_color_selected_background 0 \
#         fish_pager_color_selected_prefix 0 \
#         fish_pager_color_selected_completion 0 \
#         fish_pager_color_selected_description 0 \
#         fish_pager_color_secondary_background 0 \
#         fish_pager_color_secondary_prefix 0 \
#         fish_pager_color_secondary_completion 0 \
#         fish_pager_color_secondary_description 0

#     set -l colors
#     for var in (set --universal --names)
#         string match --regex --quiet "^fish_(pager_)?color.*" -- $var; or continue
#         if contains --index -- $var $syntax_highlighting_variables | read index
#             set syntax_highlighting_variables[(math "$index + 1")] 1
#             # echo $var
#             continue
#         end

#         if contains --index -- $var $pager_color_variables | read index
#             set pager_color_variables[(math "$index + 1")] 1
#             # echo $var
#             continue
#         end
#         # echo
#         # set -a colors $var
#     end

#     # for i in (seq (math (count $syntax_highlighting_variables) / 2))
#     # echo "len: " (count $syntax_highlighting_variables)

#     printf '%sSyntax Highlighting Variables%s\n' (set_color --bold) $reset
#     printf '%s%s%s\n' (set_color blue --underline) https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables $reset
#     echo
#     # string repeat --count $COLUMNS -
#     for i in (seq 1 2 (count $syntax_highlighting_variables))
#         set -l var $syntax_highlighting_variables[$i]
#         set -l url https://fishshell.com/docs/current/interactive.html#envvar-$var

#         printf ' - '

#         set -l color $reset
#         set -l postfix 'NOT DEFINED'
#         set -l postfix_color (set_color --background brred '#000000')
#         set -l defined $syntax_highlighting_variables[(math "$i + 1")]

#         if test $defined -eq 1
#             set color $$var
#             set postfix $$var
#             set postfix_color $reset
#         end

#         # hyperlink in terminal standard: https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
#         set_color $color
#         printf "\e]8;;"
#         printf '%s' $url
#         printf '\e\\'
#         printf '%s' $var
#         printf '\e]8;;\e\\'
#         set_color normal
#         printf ' %s %s %s\n' $postfix_color $postfix $reset
#     end

#     echo

#     printf '%sPager Color Variables%s\n' (set_color --bold) $reset
#     printf '%s%s%s\n' (set_color blue --underline) https://fishshell.com/docs/current/interactive.html#pager-color-variables $reset
#     echo
#     # set_color --dim
#     # string repeat --count $COLUMNS -
#     # set_color normal

#     for i in (seq 1 2 (count $pager_color_variables))
#         set -l var $pager_color_variables[$i]
#         set -l defined $pager_color_variables[(math "$i + 1")]
#         # TODO: check if empty ie. `test -z $var`

#         set -l url https://fishshell.com/docs/current/interactive.html#envvar-$var

#         printf ' - '

#         set -l color $reset
#         set -l postfix 'NOT DEFINED'
#         set -l postfix_color (set_color --background brred '#000000')
#         set -l defined $pager_color_variables[(math "$i + 1")]

#         if test $defined -eq 1
#             set color $$var
#             set postfix $$var
#             set postfix_color $reset
#         end

#         # hyperlink in terminal standard: https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
#         set_color $color
#         printf "\e]8;;"
#         printf '%s' $url
#         printf '\e\\'
#         printf '%s' $var
#         printf '\e]8;;\e\\'
#         set_color normal
#         printf ' %s %s %s\n' $postfix_color $postfix $reset

#         # printf ' - '
#         # if test $defined -eq 1
#         #     printf '%s%s%s %s\n' (set_color $$var) $var $reset $$var
#         #     # echo $var
#         # else
#         #     # https://fishshell.com/docs/current/interactive.html#envvar-fish_pager_color_progress
#         #     set -l url https://fishshell.com/docs/current/interactive.html#envvar-$var
#         #     # set_color --background brred
#         #     # echo "not defined: " $var
#         #     printf '%s %s NOT DEFINED %s\n' $var (set_color --background brred '#000000') $reset
#         # end
#     end

#     # set max_width 0
#     # for c in $colors
#     #     set -l width (string length -- $c)
#     #     set max_width (math "max $max_width, $width")
#     # end

#     # for c in $colors
#     #     printf "%s%s%s (set_color %s)\n" (set_color $$c) $c $reset $$c
#     # end

# end
