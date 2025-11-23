{
  config,
  lib,
  pkgs,
  ...
}:

let
  range = from: to: builtins.genList (i: from + i) (to - from);
in
{

  wayland.windowManager.hyprland = {
    # enable = osConfig.programs.hyprland.enable;
    enable = false;
    # xwayland.enable = osConfig.programs.hyprland.xwayland.enable;
    xwayland.enable = false;
    systemd.enable = true;
    plugins = [
      # inputs.hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
    ];
    settings.exec-once = [
      # "${pkgs.hyprpanel}/bin/hyprpanel"
    ];
    extraConfig =
      # hyprconf
      ''
        exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
        exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

        windowrule = animation slide left,kitty
        windowrule = animation popin,dolphin
        windowrule = noblur,^(firefox)$ # disables blur for firefox

        windowrulev2 = float, class:(floating) # class for floating windows
        windowrulev2 = tile, class:raylib # to make gbpplanner easier to work with

        windowrulev2 = bordercolor rgb(E54430), class:firefox
        windowrulev2 = bordercolor rgb(4F5BDA), class:WebCord
        windowrulev2 = bordercolor rgb(1BC156), class:Spotify
        windowrulev2 = bordercolor rgb(4A7AAE), class:telegram
        windowrulev2 = bordercolor rgb(FF00FF) rgb(880808),fullscreen:1 # set bordercolor to red if window is fullscreen
        windowrulev2 = bordercolor rgb(FFFF00),title:^(.*Hyprland.*)$ # set bordercolor to yellow when title contains Hyprland
        windowrulev2 = bordercolor rgb(FF0000),title:^(.*YouTube.*)$ # set bordercolor to red when title contains YouTube
        windowrulev2 = bordercolor rgb(E53E00),title:^(.*Reddit.*)$

        monitor = DP-5, 2560x1440@60, 0x0, 1, bitdepth, 10 # acer monitor at home
        # monitor = HDMI-A-1 1920x1080@60, 0x0, 1 # monitor borrowed from RIA
        monitor = eDP-1, 2560x1600@60, 0x1440, 1 # tuxedo laptop

        # monitor=DP-1,2560x1600@60,0x0,1,vrr,1
        # monitor=DP-1,2560x1600@60,0x0,1,bitdepth,10
        # recommended rule for quickly pluggin in random monitors
        # monitor=,preferred,auto,1
        monitor=,highres,auto,1
        # monitor=,highrr,auto,1
      '';
    settings = {
      "$super" = "SUPER";

      bindl =
        let
          name = "19b7b30";
        in
        [
          # https://wiki.hyprland.org/Configuring/Binds/#switches
          ",switch:${name}, exec, hyprlock"
        ];
      # mouse bindings
      bindm = [ "ALT,mouse:272,movewindow" ];
      # key bindings
      bind =
        [
          ", f11, fullscreen, 1"
          "SHIFT, f11, fullscreen, 2"
          "CTRL, f11, fullscreen, 0"
          "SUPER, r, layoutmsg, orientationnext"
          "SUPERSHIFT, m, layoutmsg, swapwithmaster"
          "SUPER, space, layoutmsg, swapwithmaster"

          # "focusmonitor"
          # "movecurrentworkspacetomonitor"
          # "swapactiveworkspaces"
          "SUPER, c, movetoworkspace, special"
          "SUPER, q, killactive"

          "SUPER, a, exec, anki"
          # "SUPER, a, exec, ~/.config/hypr/bin/hyprland-arise --class anki"
          # "SUPER, f, exec, flatpak run io.github.zen_browser.zen"

          # "SUPER, f, exec, ~/.config/hypr/bin/hyprland-arise --class firefox"

          # "$super, K, exec, wezterm-gui start"
          # "SUPER, k, exec, kitty"
          # "SUPER, k, exec, wezterm-gui start"
          # "SUPER, k, exec, alacritty"
          # "SUPER, k, exec, ~/.config/hypr/bin/hyprland-arise --class kitty"
          "SUPER, t, exec, ${lib.getExe config.default-application.terminal}"

          "SUPER, s, exec, spotify"
          # "SUPER, s, exec, ~/.config/hypr/bin/hyprland-arise --class spotify"
          # "SUPER, d, exec, discord"
          "SUPER, d, exec, vesktop"
          # "SUPER, d, exec, ~/.config/hypr/bin/hyprland-arise --class webcord"

          "SUPER, m, exec, thunderbird # mail"
          # "SUPER, m, exec, ~/.config/hypr/bin/hyprland-arise --class thunderbird"

          "SUPER, g, exec, telegram-desktop"
          # "SUPER, t, exec, ~/.config/hypr/bin/hyprland-arise --class org.telegram.desktop --exec telegram-desktop"

          # "SUPERSHIFT, o, exec, obs # obs-studio"
          # "SUPER, o, exec, ~/.config/hypr/bin/hyprland-arise --class com.obsproject.Studio --exec obs"
          # "SUPERSHIFT, e, exec, ~/.config/hypr/bind/hyprland-arise --class dolphin"
          "SUPER, e, exec, dolphin"

          # "SUPER, p, exec, ~/.config/hypr/bind/hyprland-arise --class okular"
          # "SUPERSHIFT, p, exec, okular # pdf"

          # "SUPER, z, exec, ~/.config/hypr/bind/hyprland-arise --class Zotero"
          # "SUPERSHIFT, z, exec, zotero"

          # bind = SUPER, V, exec,  <terminal name> --class floating -e <shell-env>  -c 'clipse $PPID' # bind the open clipboard operation to a nice key.
          # "ALT, space, exec, krunner"
          # "ALT, space, exec, wofi --show drun"
          # "ALT, space, exec, rofi -show drun -show-icons"
          "SUPER, slash, exec, ${lib.getExe config.programs.fuzzel.package}"

          "SUPER, mouse_down, workspace, e-1"
          "SUPER, mouse_up, workspace, e+1"
          # "SUPERSHIFT, f, togglefloating"
          ", xf86audioplay, exec, playerctl play-pause "
          ", xf86audionext, exec, playerctl next"
          ", xf86audioprev, exec, playerctl previous"
          ", xf86audiostop, exec, playerctl stop"
          ", xf86audioraisevolume, exec, pamixer -i 5"
          ", xf86audiolowervolume, exec, pamixer -d 5"

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          "SUPER CTRL,  h, movewindow, l"
          "SUPER CTRL,  l, movewindow, r"
          "SUPER CTRL,  k, movewindow, u"
          "SUPER CTRL,  j, movewindow, d"

          "SUPER CTRL,  left, movewindow, l"
          "SUPER CTRL,  right, movewindow, r"
          "SUPER CTRL,  up, movewindow, u"
          "SUPER CTRL,  down, movewindow, d"

          "SUPERSHIFT, left, resizeactive, -5% 0"
          "SUPERSHIFT, right, resizeactive, 5% 0"
          "SUPERSHIFT, up, resizeactive, 0 -5%"
          "SUPERSHIFT, down, resizeactive, 0 5%"

          "SUPER, Tab, workspace,previous" # cycle recent workspaces
          "ALT, Tab, cyclenext"
          "ALT, Tab, bringactivetotop"
          "SHIFT ALT, Tab, cyclenext, prev"

          # Goto next/previous workspaces
          "SUPER, bracketright, workspace, e+1"
          "SUPER, bracketleft, workspace, e-1"

          ", PRINT, exec, hyprshot -m region"
          "CTRL, PRINT, exec, hyprshot -m window"
          "SHIFT, PRINT, exec, hyprshot -m output" # screenshot a monitor

          # Move/Resize windows with mainMod + LMB/RMB and dragging
          # "bindm = SUPER, mouse:272, movewindow"
          # "bindm = SUPER, mouse:273, resizewindow"
        ]
        # ++ pipe (range 1 10) [builtins.toString (i: "SUPER, ${i}, workspace, ${i}")];
        ++ map (
          i:
          let
            n = builtins.toString i;
          in
          "SUPER, ${n}, workspace, ${n}"
        ) (range 1 10)
        ++ map (
          i:
          let
            n = builtins.toString i;
          in
          "SUPER CTRL, ${n}, movetoworkspace, ${n}"
        ) (range 1 10);

      animations = {
        enabled = true;
        first_launch_animation = true;
      };
      # decorations = {
      #   rounding = 10;
      #   blur = {
      #     enabled = true;
      #     size = 3;
      #     passes = 1;
      #   };
      #   drop_shadow = "yes";
      # };
      #
      input = {
        kb_layout = "us,dk";
        kb_options = "grp:win_space_toggle";
        # kb_layout = "us,dk";
        # kb_options = "grp:alt_shift_toggle, caps:swapescape";
        # kb_options = "grp:alt_shift_toggle";
        # https://wiki.hyprland.org/Configuring/Variables/#follow-mouse-cursor
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.0;
          disable_while_typing = true;
          middle_button_emulation = true;
          drag_lock = true;
        };
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 1;
        no_border_on_floating = false;
        layout = "master"; # oneof ["dwindle" "master"]
        resize_on_border = true;
        hover_icon_on_border = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 300; # px
        # workspace_swipe_touch = false;
        workspace_swipe_invert = true;
        workspace_swipe_create_new = true;
      };

      group = {
        groupbar = {
          enabled = true;
        };
      };

      decoration = {
        rounding = 5; # px
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        drop_shadow = true;
        dim_inactive = true;
        dim_strength = 0.1;

        blur = {
          enabled = false;
          passes = 1;
          popups = false;
        };
      };

      # master = {
      #   new_is_master = true;
      # };

      misc = {
        disable_hyprland_logo = false;
        disable_splash_rendering = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        focus_on_activate = true;
        # enable_hyprcursor = true;
        # vfr = true;
      };
    };
  };

  # # TODO: use ini generator from nixpkgs.
  # xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text =
  #   # ini
  #   ''
  #     [preferred]
  #     default=hyprland;gtk
  #     org.freedesktop.impl.portal.FileChooser=kde
  #     org.freedesktop.impl.portal.Screencast=kde
  #   '';

  home.packages = with pkgs; [
    hyprlock # wayland screen lock
    hypridle # hyprlands idle daemon
    # hyprpanel
  ];

  xdg.configFile."hypr/hypridle.conf".text =
    # hyprconf
    ''
      general {
          lock_cmd = notify-send "lock!"          # dbus/sysd lock command (loginctl lock-session)
          unlock_cmd = notify-send "unlock!"      # same as above, but unlock
          before_sleep_cmd = notify-send "Zzz"    # command ran before sleep
          after_sleep_cmd = notify-send "Awake!"  # command ran after sleep
          ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
      }

      listener {
          timeout = 500                            # in seconds
          on-timeout = notify-send "You are idle!" # command to run when timeout has passed
          on-resume = notify-send "Welcome back!"  # command to run when activity is detected after timeout has fired.
      }
    '';

  # https://github.com/hyprwm/hyprpicker/issues/51#issuecomment-2016368757
  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.adwaita-icon-theme;
  #   name = "Adwaita";
  #   size = 16;
  # };
}
