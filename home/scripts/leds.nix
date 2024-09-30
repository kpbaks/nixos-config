{ pkgs, ... }:
let
  script =
    pkgs.writers.writeFishBin "leds" { }
      # fish
      ''
        set -l options w/watch=
        argparse $options -- $argv; or return 2

        set -l subcommand list
        if test (count $argv) -gt 0
            set subcommand $argv[1]
        end


        set -l timeout 1s

        switch $subcommand
            case list
        end

        # Hide cursor
        printf "\033[?25l"

        while true

            set -l leds /sys/class/leds/*
            set -l physical_device_names (command cat /sys/class/leds/*/device/name)

            set -l len_longest_path 0
            for led in $leds
                set -l len (string length -- $led)
                set len_longest_path (math "max $len_longest_path, $len")
            end

            # set -l len_longest_name 0
            # for name in $names
            #     set -l len (string length -- $name)
            #     set len_longest_name (math "max $len_longest_path, $len")
            # end

            set -l reset (set_color normal)
            set -l bold (set_color --bold)
            set -l dim (set_color --dim)
            set -l blue (set_color blue)
            set -l green (set_color green)

            set -l names (command cat /sys/class/leds/*/device/name | sort --unique)
            set -l colors red yellow blue cyan magenta green
            set -l ncolors (count $colors)
            printf '%sdevices%s\n' (set_color --bold) $reset
            for i in (seq (count $names))
                set -l color $colors[(math "max(1, $i % $ncolors)")]
                printf '[%s%s%s] %s"%s"%s\n' (set_color $color) $i $reset $green $names[$i] $reset
            end

            echo

            printf '%sleds%s\n' $bold $reset
            for led in $leds
                read max_brightness <$led/max_brightness
                read brightness <$led/brightness
                path basename $led | read name
                if string match --quiet 'input*' -- $name
                else if string match --quiet '*backlight' -- $name
                end
                # TODO: detect what physical device each led belong, as there are more when e.g. an external keyboard is connected

                set -l rpad (math "$len_longest_path - $(string length -- $led) + 1")
                set rpad (string repeat --count $rpad ' ')
                set -l brightness_color

                if test -r $led/device/name
                    read device_name <$led/device/name
                    set -l color_idx (contains --index -- $device_name $names)
                    set -l color $colors[(math "max(1, $color_idx % $ncolors)")]
                    set color (set_color $color)
                    printf '[%s%d%s] ' $color $color_idx $reset
                else
                    printf '[_] '
                end

                printf '%s%s%s/%s%s%s%s %d/%d' $dim /sys/class/leds $reset $blue $name $reset $rpad $brightness $max_brightness
                # if test $brightness -gt 0
                set -l ratio (math "$brightness / $max_brightness")
                set -l total_width 20
                set -l gauge_width (math "floor($ratio * $total_width)")
                set -l remainder_width (math "$total_width - $gauge_width")
                printf ' '
                set_color green
                string repeat --count $gauge_width - --no-newline
                set_color normal
                set_color --dim
                string repeat --count $remainder_width - --no-newline
                set_color normal
                # end

                echo
            end

            if not set -q _flag_watch
                break
            end



            sleep $timeout


            # Move cursor up n_lines lines to overwrite previous output next iteration
            set -l nlines (math "$(count $names) + $(count $leds) + 3")
            for i in (seq $nlines)
                printf "\033[1A"
            end
        end


        # Show cursor
        printf "\033[?25h"
      '';
in
{
  home.packages = [ script ];
}
