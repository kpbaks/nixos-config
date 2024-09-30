{ pkgs, ... }:
let
  script =
    pkgs.writers.writeFishBin "displays" { }
      # fish
      ''
        set -l options h/help n/names c/connected d/disconnected
        if not argparse $options -- $argv
            eval (status function) --help
            return 2
        end

        if set -q _flag_help
            echo todo
            return 0
        end

        if set -q _flag_connected; and set -q _flag_disconnected
            echo "mutually exclusive"
            return 2
        end

        set -l reset (set_color normal)
        set -l b (set_color --bold)
        set -l dim (set_color --dim)
        set -l green (set_color green)
        set -l blue (set_color blue)
        set -l cyan (set_color cyan)
        set -l magenta (set_color magenta )
        set -l red (set_color red)
        set -l yellow (set_color yellow)

        for drm in /sys/class/drm/*
            test -r $drm/status; or continue

            set -l color $dim
            set -l connected 0
            set -l dim_if_disconnected --dim
            if string match --quiet connected <$drm/status
                set color $green
                set connected 1
                set dim_if_disconnected
            end



            set -l name (path basename $drm | string replace --regex '^card\drm-' "")

            # printf '%s%s%s\n' $color $name $reset
            printf '%s%s%s -> %s%s%s\n' $color $name $reset $color $drm $reset
            # printf '  name: %s\n' $name


            set -l connector_kind (path basename $drm | string match --groups-only --regex '^card\d-([^-0-9]+)')
            set -l connector_kind_friendly_name
            set -l connector_kind_color
            switch $connector_kind
                case eDP LVDS
                    set connector_kind_friendly_name laptop-screen
                    set connector_kind_color (set_color --background blue '#000000' --bold $dim_if_disconnected)
                case HDMI
                    set connector_kind_friendly_name HDMI
                    set connector_kind_color (set_color cyan $dim_if_disconnected)
                case DP
                    set connector_kind_friendly_name DisplayPort
                    set connector_kind_color (set_color magenta $dim_if_disconnected)
                case VGA
                    set connector_kind_friendly_name VGA
                    set connector_kind_color (set_color red $dim_if_disconnected)
                case '*'
                    continue
            end

            printf '  %sconnection:%s %s%s%s\n' (set_color $dim_if_disconnected) $reset $connector_kind_color $connector_kind_friendly_name $reset
            # echo $drm
            if test $connected -eq 1
                # Each line in $drm/modes is <width>x<height>
                # Sort by <width>
                set -l modes (command sort --numeric-sort --field-separator x --key 1 --unique --reverse <$drm/modes)
                printf '  modes:\n'
                printf '    - %s\n' $modes



            end

            # TODO: convert pixel dims to cm or mm, using its pixel density constant

            # TODO: how is this different from $d/status?
            # cat $d/enabled 
            # TODO: what is this?
            # cat $d/dpms 
            # TODO: what is this?
            # cat $d/connector_id 

            # cat $d/modes # list available display resolution modes

            # if command -q edid-decode
            #     edid-decode <$d/edid
            # end
        end
      '';
in
{
  home.packages = [ script ];
}
