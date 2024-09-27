{
  config,
  pkgs,
  ...
}:
with config.flavor;
{
  home.packages = with pkgs; [

    # Kitty tools
    pixcat
    # termpdfpy # TODO: also try out tdf https://github.com/itsjunetime/tdf when it gets a nixpkgs
    kitty-img # Print images inline in kitty
    # presenterm # A markdown terminal slideshow tool
    # https://github.com/chase/awrit
  ];

  # home.file.".config/kitty/tokyonight-storm.conf".source = ./extra/kitty/tokyonight-storm.conf;
  # home.file.".config/kitty/catppuccin-latte.conf".source = ./extra/kitty/catppuccin-latte.conf;
  # home.file.".config/kitty/catppuccin-macchiato.conf".source = ./extra/kitty/catppuccin-macchiato.conf;
  programs.kitty = {
    enable = true;
    # catppuccin.enable = false;
    environment = {
      # LS_COLORS = "1";
    };
    font.name = "JetBrainsMono Nerd Font Mono";
    # font.name = "Iosevka Nerd Font Mono";
    font.size = 18;
    # https://sw.kovidgoyal.net/kitty/actions/
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
      # "ctrl+g" = "show_last_command_output";
      "ctrl+shift+h" = "show_scrollback";
      "ctrl+shift+e" = "open_url_with_hints";
      "ctrl+shift+f1" = "show_kitty_doc overview";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "ctrl+home" = "scroll_home";
      "ctrl+end" = "scroll_end";
      f11 = "toggle_fullscreen";

      "ctrl+shift+page_up" = "previous_tab";
      "ctrl+shift+page_down" = "next_tab";
      "ctrl+shift+home" = "goto_tab 1";
      "ctrl+shift+end" = "goto_tab 99";
      "ctrl+shift+d" = "detach_tab";

      # TODO: write a custom python scripts that, check if the window is the one most to the right,
      # if it is either spawn a new window in that direction, or create a tab in that direction.
      # Switch focus to the neighboring window in the indicated direction
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      # TODO: combine the 2, based on in alternative screen or not
      "ctrl+shift+up" = "scroll_to_prompt -1";
      "ctrl+shift+down" = "scroll_to_prompt 1";
      # "ctrl+shift+up" = "neighboring_window up";
      # "ctrl+shift+down" = "neighboring_window down";
    };
    extraConfig = # kittyconf
      ''
        mouse_map left release grabbed,ungrabbed mouse_handle_click link
      '';
    settings = {
      background_opacity = "0.99";
      dim_opacity = "0.5";
      allow_remote_control = "yes";
      dynamic_background_opacity = "yes";
      # listen_on =
      disable_ligatures = "never";
      modify_font = "underline_thickness 100%";
      # modify_font = "strikethrough_position 2px";
      undercurl_style = "thick-sparse";
      confirm_os_window_close = 0;
      window_padding_width = 6;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      bell_on_tab = "🔔 ";
      visual_bell_duration = "2.0 ease-in linear";
      visual_bell_color = red.hex;
      update_check_interval = 0;
      sync_to_monitor = true; # sync frame-rate to match with monitor
      window_alert_on_bell = "yes";
      # command_on_bell = "none";
      # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.command_on_bell
      # TODO: on `niri` ask compositor to focus window, and kitty to focus the tab
      # TODO: or more general use the wayland protocol to ask for window/focus to be more
      # compositor agnostic
      command_on_bell = pkgs.lib.getExe (
        pkgs.writers.writeFishBin "kitty_command_on_bell" { }
          # fish
          ''
            # TODO: estimate which binary we have run, e.g. if we ran cargo build it would be funny to have the
            # icon be a ferris crab
            ${pkgs.libnotify}/bin/notify-send --icon=kitty kitty "The bell rang: KITTY_CHILD_CMDLINE"
          ''
      );
      # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.bell_path
      # TODO: find some funny soundclip to play
      bell_path = "none";
      # background_opacity = 0.9;
      strip_trailing_spaces = "smart";
      # Links
      allow_hyperlinks = "yes";
      # TODO: use catppuccin color
      # url_color = "#0087bd";
      url_color = sky.hex;
      # url_style = "curly";
      url_style = "dotted";
      open_url_with = "default";
      detect_urls = "yes";
      show_hyperlink_targets = "yes";
      # underline_hyperlinks = "hover";
      underline_hyperlinks = "always";

      touch_scroll_multiplier = 18;
      # window_logo_path = xdg.configFile."kitty/kitty-logo.png";
      # window_logo_position = "bottom-right";
      # window_logo_alpha = "0.5";
      # window_logo_scale = 0;
      paste_actions = "no-op";

      watcher = "${config.xdg.configHome}/kitty/watcher.py";

      window_border_width = "4px";
      draw_minimal_borders = "no";

      tab_bar_edge = "top";
      tab_bar_margin_width = "0.0";
      tab_bar_margin_height = "0.0 0.0";
      # tab_bar_style = "slant";
      tab_bar_style = "powerline";
      tab_bar_align = "center";
      tab_bar_min_tabs = 2;
      # tab_switch_strategy  = "previous";
      tab_switch_strategy = "last";
      tab_activity_symbol = "⏰";
      # TODO: use catppuccin color
      # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.tab_title_template
      tab_title_template = "{fmt.fg.red}{bell_symbol} {activity_symbol}{fmt.fg.tab}{title}";
      tab_bar_background = surface0.hex;
      tab_bar_margin_color = flamingo.hex;
    };
    shellIntegration.mode = "no-cursor";
    shellIntegration.enableFishIntegration = true;
    shellIntegration.enableBashIntegration = true;
  };

  # TODO: make a custom tab bar
  # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.tab_bar_style
  # https://github.com/kovidgoyal/kitty/discussions/4447
  xdg.configFile."kitty/tab_bar.py".text =
    # python
    ''

    '';

  # https://sw.kovidgoyal.net/kitty/launch/#watching-launched-windows
  # TODO: `on_cmd_startstop` create a handler than check if kitty is not in focus, and the last command run took more than 5 seconds,
  # and then create a notification to inform user that the task has completed, with a button to focus the terminal
  # This can be done with `kitten` and `notify-send`
  # man 26 aug 11:52:04 CEST 2024
  xdg.configFile."kitty/watcher.py".source = ./watcher.py;

  # TODO: create pr to `home-manager` to have a dedicated option for this
  # https://sw.kovidgoyal.net/kitty/open_actions/
  # TODO: create pr to `kitty` to have mouse_over_hyperlink events to react to
  xdg.configFile."kitty/open-actions.conf".text =
    # kittyconf
    ''
      # Open any image in the full kitty window by clicking on it
      protocol file
      mime image/*
      action launch --type=vsplit kitten icat --hold -- $${FILE_PATH}

      # Tail a log file (*.log) in a new OS Window and reduce its font size
      protocol file
      ext log
      action launch --title $${FILE} --type=os-window tail -f -- $${FILE_PATH}
      action change_font_size current -2

      # Open ssh URLs with ssh command
      protocol ssh
      action launch --type=os-window ssh -- $URL

      # Open man URLs with man command
      protocol man
      action launch --type=window man -- $URL

      # Open a compose mail window in thunderbird to any mail address clicked on
      protocol mailto
      action launch thunderbird -compose "to=\'$${FILE_PATH}\'"

      # TODO: figure out something useful to do here
      # protocol tel
      # action launch ...

      protocol file
      mime inode/file
      action launch --type=os-window --cwd -- hx $FILE_PATH


      # Open directories
      # TODO: use yazi
      protocol file
      mime inode/directory
      action launch --type=os-window --cwd -- $FILE_PATH
    '';

  # https://sw.kovidgoyal.net/kitty/kittens/diff/
  xdg.configFile."kitty/diff.conf".text = # kittyconf
    ''
      map q quit
      map esc quit

      map j scroll_by 1
      map down scroll_by 1

      map k scroll_by -1
      map up scroll_by -1

      map home scroll_to start
      map end scroll_to end
    '';

  # xdg.configFile."kitty/kitty-logo.png" = ./kitty-logo.png;

}

# function kitty-options
#     if not set -q KITTY_PID
#         return 2
#     end

#     set -l reset (set_color normal)
#     set -l dim (set_color --dim)
#     set -l b (set_color --bold)

#     set -l i 0
#     set -l base_url https://sw.kovidgoyal.net/kitty/conf/#opt-kitty

#     set -l query '*'
#     if test (count $argv) -gt 0
#         if contains -- '*' (string split '' -- $argv)
#             set query $argv[1]
#         else
#             set query "*$argv[1]*"
#         end
#     end

#     command kitty +runpy "
# import kitty.config
# for opt in kitty.config.option_names_for_completion():
#     print(opt)
# " | string match -- $query | while read opt
#         set -l opt_urlname $opt
#         if string match --regex --groups-only 'color(\d+)' -- $opt | read n
#             test $n -gt 16; and continue # There are no anchor links to colors >=16
#             if test $n -ge 8
#                 # quirk of how the colors are anchored in the documentation
#                 # color0 and color8 are shown together
#                 # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.color0
#                 # color1 and color9
#                 # and so on
#                 set opt_urlname color(math "$n - 8")
#             end
#         end

#         set -l color $b
#         if test (math "$i % 2") -eq 1
#             set color $dim
#         end

#         # TODO: highlight the characters the query matches

#         set -l url "$base_url.$opt_urlname"
#         printf "\e]8;;"
#         printf '%s' $url
#         printf '\e\\'
#         printf '%s%s%s' $color $opt $reset
#         # printf '%s%s%s.%s\n' $dim $base_url $reset $opt
#         printf '\e]8;;\e\\'
#         printf '\n'

#         set i (math $i + 1)
#     end
# end

# function kitty-resolution
#     if not set -q KITTY_PID
#         return 2
#     end

#     command kitten icat --print-window-size | read --delimiter x width height
#     set -l cell_width_px (math "round($width / $COLUMNS)")
#     set -l cell_height_px (math "round($height / $LINES)")

#     set -l reset (set_color normal)
#     set -l c (set_color $fish_color_option)
#     printf '%scolumns%s = %d cells\n' $c $reset $COLUMNS
#     printf '%slines%s = %d cells\n' $c $reset $LINES
#     printf '%swidth%s = %dpx\n' $c $reset $width
#     printf '%sheight%s = %dpx\n' $c $reset $height
#     printf '%scell.density.width%s = %dpx\n' $c $reset $cell_width_px
#     printf '%scell.density.height%s = %dpx\n' $c $reset $cell_height_px
# end
