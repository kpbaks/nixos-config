{ pkgs, ... }:
let
  inherit (builtins)
    map
    attrNames
    removeAttrs
    readDir
    unsafeGetAttrPos
    ;
  inherit (pkgs.lib) filterAttrs pipe;
  topath = s: ./. + "/${s}";

  # FIXME: causes infinite recursion
  readdir =
    dir:
    pipe (readDir dir) [
      (filterAttrs (k: v: v == "regular" && k != "default.nix"))
      attrNames
      topath
    ];
in

{
  imports = [
    ./fonts.nix
    ./leds.nix
    ./xkcd.nix
    ./displays.nix
    ./bluetooth-devices.nix
    ./ocr.nix
    ./flake-inputs.nix
    # ./tokei-pie.nix
    # ./cdtmp.nix
  ];
  # imports = readdir ./.;

  # home.packages = 1;

  # imports = builtins.map (n: toString ./. + "/${n}") (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) [(builtins.unsafeGetAttrPos "_" {_ = null;}).file]));

}

# systemd.user.services.open-https-urls-copied-to-clipboard = {
#   # Unit.description = "Open https urls copied to clipboard in $BROWSER";
#   Install.WantedBy = [ "graphical-session.target" ];
#   Service.ExecStart = (
#     pkgs.lib.getExe (
#       pkgs.writers.writeFishBin "__open-https-urls-copied-to-clipboard" { }
#         # fish
#         ''
#           # wl-paste
#           ${pkgs.wl-clipboard}/bin/wl-paste --watch echo "" | while read _ignore
#             set -l content (${pkgs.wl-clipboard}/bin/wl-paste)
#             if string match --regex "^\s*https?://\S+" -- $content
#               ${pkgs.firefox}/bin/firefox (string trim -- "$content")
#             end
#           end
#         ''
#     )
#   );
# };

# systemd.user.services.periodically-change-wallpaper-to-random-color = {
#   Unit.description = "Periodically change wallpaper of all monitors to a random color";
#   Install.WantedBy = [ "graphical-session.target" ];
#   Timer.Service.ExecStart = pkgs.lib.getExe scripts.change-wallpaper-to-random-color;
# };

# # TODO: finish
# # TODO: come up with a better name
# # https://haseebmajid.dev/posts/2023-10-08-how-to-create-systemd-services-in-nix-home-manager/
# systemd.user.services.rfkill-notify-when-devices-state-changes = {
#   # unit.description = "display notification whenever the on/off state of either wifi or bluetooth changes";
#   install.wantedby = [ "graphical-session.target" ];
#   service.execstart =
#     pkgs.writers.writeFishBin "__rfkill-notify-when-devices-state-changes" { }
#       # fish
#       ''

#         ${pkgs.util-linux}/bin/rfkill event | while read date time _idx id _type type _op op _soft soft _hard hard

#         switch $soft
#           case 0 # unblocked
#           case 1 # blocked
#         end

#         end
#       '';
# };

# scripts.change-wallpaper-to-random-color =
#   pkgs.writers.writeFishBin "change-wallpaper-to-random-color" { }
#     # fish
#     ''
#       # IDEA: cycle between catppuccin colors
#       set -l r (printf '%x\n' (random 0 255))
#       set -l g (printf '%x\n' (random 0 255))
#       set -l b (printf '%x\n' (random 0 255))
#       set -l color $r$g$b

#       set -l nixos_logo_svg_url https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg
#       # set -l nixos_logo_svg /tmp/(status filename).svg
#       set -l nixos_logo_svg /tmp/(path basename $nixos_logo_svg_url)
#       set -l nixos_logo_png (path change-extension png $nixos_logo_svg)
#       # set -l wallpaper

#       if not test -f $nixos_logo_svg
#         ${pkgs.curl}/bin/curl --silent $nixos_logo_svg_url --output - > $nixos_logo_svg
#         ${pkgs.imagemagick}/bin/magick -background none $nixos_logo_svg $nixos_logo_png
#       end

#       set -l tmpf (${pkgs.coreutils-full}/bin/mktemp --suffix .png)
#       ${pkgs.imagemagick}/bin/magick $nixos_logo_png -gravity center -background "#$color" -extent 1920x1080 $tmpf

#       # convert logo.png -gravity center -background white -extent 1920x1080 output.png
#       # ${pkgs.imagemagick}/bin/magick -size 1x1 xc:"#$color" $tmpf

#       # TODO: print notification if swww failed e.g. run with wayland compositor like Gnome that
#       # does not support 'wlr-layer-shell' protocol
#       ${inputs.swww.packages.${pkgs.system}.swww}/bin/swww img $tmpf --transition-type any
#       ${pkgs.coreutils-full}/bin/rm $tmpf
#     '';

# scripts.search-clipboard-content-with-browser-search-engine =
#   pkgs.writers.writeFishBin "search-clipboard-content-with-browser-search-engine" { }
#     # fish
#     ''
#       set -l title search
#       if not string match --quiet --regex text/plain -- (${pkgs.wl-clipboard}/bin/wl-paste --list-types)
#         # TODO: handle images with google image search
#         set -l icon error-symbolic

#          ${pkgs.libnotify}/bin/notify-send --icon=$icon $title "ERROR: Searching for images is not supported!"
#         return 1
#       end

#       # TODO: should multi line strings be handled differently?
#       set -l text (command wl-paste)

#       set -l icon internet-web-browser
#       set -l url
#       # TODO: handle other protocols like mailto: tel: s?ftp file:/// etc. appropriate
#       if string match --regex "^\s*https?://" -- $text
#         set url (string trim -- $text)
#       else
#         set -l body "Searching for:
#         $text
#         "
#         ${pkgs.libnotify}/bin/notify-send --transient --icon=$icon $title $body

#         set -l query (string escape --style url -- $text)
#         # TODO: figure out what is the maximum length that browsers support
#         # i.e. if we copy a full page of text the http query param probably breaks
#         # TODO: should it be handled specially if the clipboard item is a abs path to a file/dir
#         # that exists on disk?

#         set -l base_url https://duckduckgo.com/
#         set url "$base_url?q=$query"
#       end

#       ${pkgs.flatpak}/bin/flatpak run io.github.zen_browser.zen --new-tab $url
#     '';

# scripts.audio-sink =
#     pkgs.writers.writeFishBin "audio-sink" { }
#       # fish
#       ''
#         set -l subcommand change # default
#         if test (count $argv) -gt 0
#           set subcommand $argv[1]
#         end

#         set -l reset (set_color normal)
#         set -l blue (set_color blue)
#         set -l green (set_color green)
#         set -l red (set_color red)

#         switch $subcommand
#           case list
#             ${pkgs.pulseaudio}/bin/pactl --format=json list sinks \
#             | ${pkgs.jaq}/bin/jaq -r '.[] | [.index, .description, .state] | @csv' \
#             | while read --delimiter , index desc state
#               printf "%4d - %s%s%s - " $index $blue $desc $reset
#               set -l state (string sub --start=2 --end=-1 -- $state)
#               switch $state
#                 case SUSPENDED
#                   printf '%ssuspended%s' $red $reset
#                 case RUNNING
#                   printf '%srunning%s' $green $reset
#               end
#               printf '\n'
#               # set i (math "$i + 1")
#             end
#           case change
#             set -l fzf_opts \
#               --cycle \
#               --ansi \
#               --border \
#               --height=~50% \
#               --header "select which audio sink to make the active one." \
#               --bind "enter:execute-silent(${pkgs.pulseaudio}/bin/pactl set-default-sink {1})+reload(sleep 0.5; $(status filename) list)" \
#               --bind j:down \
#               --bind k:up \
#               --border-label "Change Audio Sink" \
#               --preview "${pkgs.pulseaudio}/bin/pactl --format=json info {1} | ${pkgs.jaq}/bin/jaq --color=always"
#             eval (status filename) list | ${pkgs.fzf}/bin/fzf $fzf_opts
#           case '*'
#             return 2
#         end
#         # set -l active -1
#         # set -l i 1
#         # pactl --format=json list sinks \
#         # | jaq -r '.[] | [.index, .description, .state] | @csv' \
#         # | while read --delimiter , index desc state
#         #   printf "%4d - %s%s%s - " $index $blue $desc $reset
#         #   set -l state (string sub --start=2 --end=-1 -- $state)
#         #   switch $state
#         #     case SUSPENDED
#         #       printf '%ssuspended%s' $red $reset
#         #     case RUNNING
#         #       printf '%srunning%s' $green $reset
#         #   end
#         #   printf '\n'
#         #   set i (math "$i + 1")
#         # end \
#         # | ${pkgs.fzf}/bin/fzf $fzf_opts
#         #       # bind enter to change sink, but not leave
#         # # pactl set-default-sink <index>
#       '';

# scripts.show-session =
#     pkgs.writers.writeFishBin "show-session" { }
#       # fish
#       ''

#         set -l reset (set_color normal)
#         set -l red (set_color red)
#         set -l blue (set_color blue)
#         set -l green (set_color green)
#         set -l yellow (set_color yellow)
#         set -l cyan (set_color cyan)
#         set -l magenta (set_color magenta)
#         set -l bold (set_color --bold)

#         set -l properties
#         set -l values
#         ${pkgs.systemd}/bin/loginctl show-session | while read -d = property value
#           set -a properties $property
#           set -a values $value
#         end

#         set -l length_of_longest_property 0
#         for p in $properties
#           set length_of_longest_property (math "max $length_of_longest_property,$(string length $p)")
#         end

#         for i in (seq (count $properties))
#           set -l p $properties[$i]
#           set -l v $values[$i]
#           set -l rpad (math "$length_of_longest_property - $(string length $p)")
#           set rpad (string repeat --count $rpad ' ')

#           set -l v_color $reset
#           if test $v = yes
#             set v_color $green
#           else if test $v = no
#             set v_color $red
#           else if string match --regex --quiet '^\d+$' -- $v
#             set v_color $magenta
#           else if string match --regex --quiet '^\d+(s|min)$' -- $v
#             set v_color $yellow
#           end

#           printf '%s%s%s%s = %s%s%s\n' $bold $p $reset $rpad $v_color $v $reset
#         end
#       '';

# # TODO: finish
# scripts.brightness =
#   pkgs.writers.writeFishBin "brightness" { }
#     # fish
#     ''
#       set -l ddc_sleep_multiplier 0.025
#       set -l external_display_ids (${pkgs.ddcutil}/bin/ddcutil --sleep-multiplier=$ddc_sleep_multiplier detect | string match --regex --groups-only "^Display (\d+)")
#       set -l laptop_max_brightness (${pkgs.brightnessctl}/bin/brightnessctl max)
#       set -l laptop_current_brightness (${pkgs.brightnessctl}/bin/brightnessctl get)
#       set -l laptop_percentage_brightness (math "round(($laptop_current_brightness / $laptop_max_brightness) * 100)")

#       set -l argc (count $argv)

#       switch $argc
#         case 0
#           # list current brighthess percentage of all displays
#         case 1
#           if string match --regex --groups-only "^(\d+)%?" -- $argv[1] | read new_brightness_percentage
#             if not test $new_brighthess_percentage -ge 0 -a $new_brightness_percentage -le 100
#             end
#             for id in $external_display_ids
#               ${pkgs.ddcutil}/bin/ddcutil --display $id setvcp 10 $new_brightness_percentage &; disown
#             end
#             ${pkgs.brightnessctl}/bin/brightnessctl set "$new_brightness_percentage%"
#           else
#           end
#           if
#         case '*'
#       end

#     '';
