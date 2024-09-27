{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    ./scripts
  ];

  # `niri` does not have built-in Xwayland support
  home.packages = with pkgs; [
    cage
    xwayland-run
    # FIXME: crashes when starting as a systemd service
    xwayland-satellite
  ];

  # TODO: see if this is possible in home-manager
  # https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup
  # xdg.configFile."systemd/user/niri.service.wants";
  programs.niri.enable = true;
  programs.niri.settings.prefer-no-csd = true;
  programs.niri.settings.screenshot-path = "~/Pictures/screenshots/screenshot-%Y-%m-%d %H-%M-%S.png";
  programs.niri.settings.hotkey-overlay.skip-at-startup = false;
  programs.niri.settings.workspaces."main" = {
    open-on-output = "eDP-1"; # laptop screen
  };

  programs.niri.settings.input.focus-follows-mouse = {
    enable = true;
    max-scroll-amount = "10%";
  };

  programs.niri.settings.input.touchpad.dwt = true; # "disable when typing"
  programs.niri.settings.input.warp-mouse-to-focus = true;
  programs.niri.settings.input.keyboard.track-layout = "window";

  programs.niri.settings.input.mouse.left-handed = false;

  programs.niri.settings.environment = {
    # DISPLAY = null;
    DISPLAY = ":0";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
  programs.niri.settings.cursor = {
    # TODO: figure out if this cursor pack is packaged in nixpkgs, and if it is
    # then depend on it properly.
    theme = "breeze_cursors";
    size = 32;
  };
  programs.niri.settings.input.workspace-auto-back-and-forth = true;
  programs.niri.settings.input.keyboard.xkb = {
    layout = "us,dk";
    variant = "colemak_dh_ortho"; # FIXME: xkbcommon does not regognize this value

    # options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
    options = "compose:ralt,ctrl:nocaps";
  };

  programs.niri.settings.layout = {
    gaps = 12; # px
    struts = {
      left = 0;
      right = 0;
      top = 0;
      bottom = 0;
    };
    center-focused-column = "on-overflow";
    # center-focused-column = "never";
    # center-focused-column = "always";
    preset-column-widths = [
      { proportion = 1.0 / 3.0; }
      { proportion = 1.0 / 2.0; }
      { proportion = 2.0 / 3.0; }
    ];
    # default-column-width = {proportion = 1.0 / 3.0;};
    # default-column-width.proportion = 1.0 / 2.0;
    default-column-width.proportion = 2.0 / 3.0;
    # default-column-width = {proportion = 1.0;};
    focus-ring = with config.flavor; {
      enable = true;
      width = 4;
      active.color = lavender.hex;
      inactive.color = flamingo.hex;
      # active.gradient = {
      #   from = "#80c8ff";
      #   to = "#d3549a";
      #   angle = 45;
      # };
    };
  };
  # FIXME(Mon Sep 23 01:03:38 PM CEST 2024): figure out why all window rules does
  # work
  programs.niri.settings.window-rules = [
    {
      matches = [
        {
          app-id = "okular";
          title = "^New Text Note.*";
        }
      ];
      default-column-width.proportion =
        1.0 - config.programs.niri.settings.layout.default-column-width.proportion;
    }
    {
      # TODO: verify it works
      matches = [
        { app-id = "^org.freedesktop.impl.portal.desktop.kde$"; }
      ];

      default-column-width.proportion =
        1.0 - config.programs.niri.settings.layout.default-column-width.proportion;
    }
    {
      matches = [
        {
          app-id = "^.?scrcpy(-wrapped)?$";
          at-startup = true;
        }
      ];

      default-column-width.proportion =
        1.0 - config.programs.niri.settings.layout.default-column-width.proportion;
      # variable-refresh-rate = true;
    }
    {
      draw-border-with-background = false;
      # draw each corner as rounded with the same radius
      # geometry-corner-radius =
      #   let
      #     r = 8.0;
      #   in
      #   {
      #     top-left = r;
      #     top-right = r;
      #     bottom-left = r;
      #     bottom-right = r;
      #   };
      # clip-to-geometry = true;
    }
    # {
    #   # dim unfocused windows
    #   matches = [ { is-focused = false; } ];
    #   opacity = 0.95;
    # }
    # { open-maximized = true; }
    {
      matches = [
        { app-id = "Alacritty"; }
        { app-id = "Kitty"; }
      ];
      open-maximized = false;
    }
    {
      matches = [ { app-id = "Bitwarden"; } ];
      block-out-from = "screencast";
      # block-out-from = "screen-capture";
    }
    {
      # TODO: add more rules
      # FIXME: does not match private browsing in firefox
      matches = [
        {
          app-id = "^firefox$";
          title = ".*Private Browsing$";
        }
      ];
      border.active.color = "purple";
    }

    {
      matches = [
        {
          app-id = "^firefox$";
          # title = "Extension: \(Bitwarden Password Manager\) - Bitwarden";
          title = "Extension:.*- Bitwarden";
        }
      ];
      default-column-width = {
        proportion = 1.0 / 3.0;
      };
    }
    {
      # Pops up when running `run0 <program>`
      matches = [ { app-id = "^org.kde.polkit-kde-authentication-agent-1$"; } ];
      default-column-width = {
        proportion = 1.0 / 3.0;
      };
    }
    {
      matches = [
        {
          app-id = "thunderbird";
          title = "^\d+ Reminders?$";
        }
      ];
      default-column-width.proportion = 1.0 / 3.0;
    }
    # Make border red when in a read-only directory like /etc or /dev
    {
      matches = [
        {
          app-id = "kitty";
          title = "^/";
        }
      ];
      border.active.color = "red";

    }
    # window-rule {
    #     match app-id=r#"^org\.wezfurlong\.wezterm$"#
    #     default-column-width {}
    # }
    # {
    #   matches = [ { app-id = ''r#"^org\.wezfurlong\.wezterm$"#''; } ];
    #   default-column-width = { };
    # }

  ];

  programs.niri.settings.outputs = {
    # Laptop screen
    "eDP-1" = {
      background-color = config.flavor.surface2.hex;
      scale = 1.0;
      position.x = 0;
      position.y = 0;
    };
    "Acer Technologies K272HUL T6AEE0058502" = {
      background-color = config.flavor.surface1.hex;
      scale = 1.0;
      transform.rotation = 0;
      variable-refresh-rate = "on-demand";
      position.x = 0;
      position.y = -1600;
    };
  };

  programs.niri.settings.spawn-at-startup =
    map (s: { command = pkgs.lib.strings.splitString " " s; })
      [
        "ironbar"
        # "${pkgs.swww}/bin/swww-daemon"
        "${pkgs.copyq}/bin/copyq"
        "${pkgs.eww}/bin/eww daemon"
        # "${pkgs.birdtray}/bin/birdtray"
        "${pkgs.wluma}/bin/wluma"
        # TODO: does not show-up
        # "${pkgs.telegram-desktop}/bin/telegram-desktop -startintray"
        # FIXME: does not work
        # "${pkgs.obs-studio}/bin/obs --minimize-to-tray"
      ];

  programs.niri.settings.animations.screenshot-ui-open = {
    easing = {
      curve = "ease-out-quad";
      duration-ms = 200;
    };
  };
  programs.niri.settings.animations.workspace-switch = {
    spring = {
      damping-ratio = 1.0;
      epsilon = 1.0e-4;
      stiffness = 1000;
    };
  };

  # TODO: experiment with this
  programs.niri.settings.animations.shaders = {
    window-resize = builtins.readFile ./shaders/window-resize.glsl;
    window-open = null;
    window-close = null;
  };

  # https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettingsbinds
  # TODO: wrap in `swayosd-client`
  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      terminal = pkgs.lib.getExe config.default-application.terminal;
      # sh = spawn "sh" "-c";
      fish = spawn "fish" "--no-config" "-c";
      # nu = spawn "nu" "-c";
      playerctl = spawn "playerctl";
      # brightnessctl = spawn "brightnessctl";
      # wpctl = spawn "wpctl"; # wireplumber
      # bluetoothctl = spawn "bluetoothctl";
      swayosd-client = spawn "swayosd-client";
      run-flatpak = spawn "flatpak" "run";
      # browser = spawn "${pkgs.firefox}/bin/firefox";
      browser = run-flatpak "io.github.zen_browser.zen";
      # run-in-terminal = spawn "kitty";
      # run-in-terminal = spawn "${pkgs.alacritty}/bin/alacritty";
      # run-in-terminal = spawn "${pkgs.kitty}/bin/kitty";
      run-in-terminal = spawn terminal;
      run-with-sh-within-terminal = run-in-terminal "sh" "-c";
      # run-with-fish-within-terminal = run-in-terminal "sh" "-c";
      run-with-fish-within-terminal = spawn terminal "${pkgs.fish}/bin/fish" "--no-config" "-c";
    in
    # run-in-sh-within-kitty = spawn "kitty" "sh" "-c";
    # run-in-fish-within-kitty = spawn "kitty" "${pkgs.fish}/bin/fish" "--no-config" "-c";
    # focus-workspace-keybinds = builtins.listToAttrs (map:
    #   (n: {
    #     name = "Mod+${toString n}";
    #     value = {action = "focus-workspace ${toString n}";};
    #   }) (range 1 10));
    {
      # "XF86AudioRaiseVolume".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
      # "XF86AudioLowerVolume".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
      "XF86AudioRaiseVolume".action = swayosd-client "--output-volume" "raise";
      "XF86AudioLowerVolume".action = swayosd-client "--output-volume" "lower";
      "XF86AudioMute".action = swayosd-client "--output-volume" "mute-toggle";
      "XF86AudioMicMute".action = swayosd-client "--input-volume" "mute-toggle";

      # TODO: bind to an action that toggles light/dark theme
      # hint: it is the f12 key with a shaded moon on it
      # "XF86Sleep".action = "";

      # TODO: use, this is the "fly funktion knap"
      # "XF86RFKill".action = "";

      # TODO: bind a key to the alternative to f3

      # command = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
      # command = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
      # "XF86AudioMute" = {
      #   action = wpctl "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      #   allow-when-locked = true;
      # };
      # "XF86AudioMicMute" = {
      #   action = wpctl "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      #   allow-when-locked = true;
      # };

      # "Mod+TouchpadScrollDown".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+";
      # "Mod+TouchpadScrollUp".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-";
      "Mod+TouchpadScrollDown".action = swayosd-client "--output-volume" "+2";
      "Mod+TouchpadScrollUp".action = swayosd-client "--output-volume" "-2";

      "XF86AudioPlay".action = playerctl "play-pause";
      "XF86AudioNext".action = playerctl "next";
      "XF86AudioPrev".action = playerctl "previous";
      "XF86AudioStop".action = playerctl "stop";
      "XF86MonBrightnessUp".action = swayosd-client "--brightness" "raise";
      "XF86MonBrightnessDown".action = swayosd-client "--brightness" "lower";
      # TODO: make variant for external displays
      # "Shift+XF86MonBrightnessUp".action = "ddcutil";
      # "Shift+XF86MonBrightnessDown".action = "ddcutil";
      "Mod+Shift+TouchpadScrollDown".action = swayosd-client "--brightness" "";
      "Mod+Shift+TouchpadScrollUp".action = swayosd-client "--brightness" "5%-";
      # "XF86MonBrightnessUp".action = brightnessctl "set" "10%+";
      # "XF86MonBrightnessDown".action = brightnessctl "set" "10%-";
      # "Mod+Shift+TouchpadScrollDown".action = brightnessctl "set" "5%+";
      # "Mod+Shift+TouchpadScrollUp".action = brightnessctl "set" "5%-";

      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+6".action = focus-workspace 6;
      "Mod+7".action = focus-workspace 7;
      "Mod+8".action = focus-workspace 8;
      "Mod+9".action = focus-workspace 9;

      # inherit (focus-workspace-keybinds) ${builtins.attrNames focus-workspace-keybinds};

      # "Mod+?".action = show-hotkey-overlay;
      "Mod+T".action = spawn terminal;
      "Mod+Shift+T".action = spawn terminal "${pkgs.fish}/bin/fish" "--private";
      # "Mod+F".action = spawn "firefox";
      # "Mod+Shift+F".action = spawn "firefox" "--private-window";
      "Mod+F".action = browser;
      "Mod+Shift+F".action = browser "--private-window";
      "Mod+G".action = spawn "telegram-desktop";
      "Mod+S".action = spawn "spotify";
      # "Mod+D".action = spawn "webcord";
      "Mod+D".action = spawn "vesktop";
      # "Mod+E".action = run-in-kitty "yazi";
      # TODO: detect the newest file in ~/Downloads and focus it first by doing `yazi $file`
      "Mod+E".action = run-with-sh-within-terminal "cd ~/Downloads; yazi";
      # "Mod+E".action = spawn "dolphin";
      # "Mod+B".action = spawn "overskride";
      # "Mod+B".action = run-in-terminal (pkgs.lib.getExe scripts.bluetoothctl-startup);
      # "Mod+A".action = run-in-terminal (pkgs.lib.getExe scripts.audio-sink);

      "Mod+A".action = run-in-terminal "${pkgs.alsa-utils}/bin/alsamixer --black-background --mouse --view playback";

      # "Mod+P".action = spawn (
      #   pkgs.lib.getExe scripts.search-clipboard-content-with-browser-search-engine
      # );

      # "Mod+B".action = run-in-terminal "bluetoothctl" "--init-script" "/home/${username}/.local/share/bluetoothctl/init-script";

      # (pkgs.lib.getExe bluetoothctl-init-script);
      "f11".action = fullscreen-window;
      # "Shift+f11".action = spawn (pkgs.lib.getExe scripts.wb-toggle-visibility-or-spawn);
      # "Mod+f11".action = spawn (pkgs.lib.getExe scripts.wb-toggle-visibility);
      # "Mod+Shift+E".action = quit;
      # "Mod+Ctrl+Shift+E".action = quit {skip-confirmation = true;};

      # "Mod+Y".action = spawn "${pkgs.firefox}/bin/firefox" "https://youtube.com";
      "Mod+Y".action = browser "https://youtube.com";

      "Mod+Plus".action = set-column-width "+10%";
      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Up".action = focus-window-or-workspace-up;
      "Mod+Down".action = focus-window-or-workspace-down;
      "Mod+Ctrl+Left".action = move-column-left;
      "Mod+Ctrl+Right".action = move-column-right;
      # "Mod+Ctrl+Up".action = move-window-up;
      # "Mod+Ctrl+Down".action = move-window-down;
      "Mod+Ctrl+Up".action = move-window-up-or-to-workspace-up;
      "Mod+Ctrl+Down".action = move-window-down-or-to-workspace-down;
      # "Mod+H".action = focus-column-left;
      # "Mod+L".action = focus-column-right;
      # "Mod+K".action = focus-window-up;
      # "Mod+J".action = focus-window-down;
      "Mod+Ctrl+H".action = move-column-left;
      "Mod+Ctrl+L".action = move-column-right;
      "Mod+Ctrl+K".action = move-window-up-or-to-workspace-up;
      "Mod+Ctrl+J".action = move-window-down-or-to-workspace-down;

      # TODO:
      #       Mod+Home { focus-column-first; }
      # Mod+End  { focus-column-last; }
      # Mod+Ctrl+Home { move-column-to-first; }
      # Mod+Ctrl+End  { move-column-to-last; }
      "Mod+Home".action = focus-column-first;
      "Mod+End".action = focus-column-last;
      "Mod+Ctrl+Home".action = move-column-to-first;
      "Mod+Ctrl+End".action = move-column-to-last;
      "Mod+Shift+Left".action = focus-monitor-left;
      "Mod+Shift+Down".action = focus-monitor-down;
      "Mod+Shift+Up".action = focus-monitor-up;
      "Mod+Shift+Right".action = focus-monitor-right;
      "Mod+Shift+H".action = focus-monitor-left;
      "Mod+Shift+J".action = focus-monitor-down;
      "Mod+Shift+K".action = focus-monitor-up;
      "Mod+Shift+L".action = focus-monitor-right;

      "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
      "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

      "Mod+Shift+Slash".action = show-hotkey-overlay;
      "Mod+Q".action = close-window;
      "Mod+V".action = spawn "${pkgs.copyq}/bin/copyq" "menu";
      "Mod+M".action = maximize-column;

      "Mod+K".action = spawn "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-app";

      # // There are also commands that consume or expel a single window to the side.
      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;

      # Mod+R { switch-preset-column-width; }
      # Mod+Shift+R { reset-window-height; }

      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = reset-window-height;

      # "Mod+Comma".action = consume-window-into-column;
      # "Mod+Period".action = expel-window-from-column;

      # "Mod+Comma".action = run-in-fish-within-kitty "${pkgs.helix}/bin/hx ~/dotfiles/{flake,configuration,home}.nix";
      # TODO: improve by checking if an editor process instance is already running, before spawning another
      "Mod+Comma".action = run-with-fish-within-terminal "hx ~/dotfiles/{flake,configuration}.nix";
      # "Mod+Period".action = spawn "${pkgs.swaynotificationcenter}/bin/swaync-client" "--toggle-panel";
      "Mod+Period".action = spawn "${pkgs.plasma-desktop}/bin/plasma-emojier";
      # TODO: color picker keybind

      # // Actions to switch layouts.
      #    // Note: if you uncomment these, make sure you do NOT have
      #    // a matching layout switch hotkey configured in xkb options above.
      #    // Having both at once on the same hotkey will break the switching,
      #    // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
      # // Mod+Space       { switch-layout "next"; }
      # // Mod+Shift+Space { switch-layout "prev"; }

      "Mod+Space".action = switch-layout "next";
      "Mod+Shift+Space".action = switch-layout "prev";

      "Mod+Page_Down".action = focus-workspace-down;
      "Mod+Page_Up".action = focus-workspace-up;

      "Mod+U".action = focus-workspace-down;
      "Mod+I".action = focus-workspace-up;

      "Print".action = screenshot;
      "Ctrl+Print".action = screenshot-screen;
      "Alt+Print".action = screenshot-window;

      # // Switches focus between the current and the previous workspace.
      "Mod+Tab".action = focus-workspace-previous;
      # "Mod+Return".action = spawn "anyrun";
      # "Mod+Return".action = fish "pidof anyrun; and pkill anyrun; or anyrun";
      # "Mod+Return".action = fish "pidof nwg-drawer; and pkill nwg-drawer; or nwg-drawer -ovl -fm dolphin";
      # "Mod+Return".action = fish "pidof fuzzel; and pkill fuzzel; or fuzzel";
      # TODO: use for a dashboard like view. Whenever you manage to implement it...
      # "Mod+Return".action = fish "pidof ${pkgs.walker}/bin/walker; and pkill walker; or ${pkgs.walker}/bin/walker";
      # "Mod+Slash".action = fish "pidof ${pkgs.walker}/bin/walker; and pkill walker; or ${pkgs.walker}/bin/walker";
      # "Mod+Return".action = fish "${pkgs.procps}/bin/pkill walker; or ${pkgs.walker}/bin/walker";
      # "Mod+Slash".action = fish "${pkgs.procps}/bin/pkill walker; or ${pkgs.walker}/bin/walker";
      "Mod+Slash".action = fish "${pkgs.walker}/bin/walker";

      "Mod+Shift+P".action = power-off-monitors;
      # Mod+R { switch-preset-column-width; }
      #   Mod+Shift+R { reset-window-height; }
      #   Mod+F { maximize-column; }
      #   Mod+Shift+F { fullscreen-window; }
      #   Mod+C { center-column; }
      # "Mod+Shift+R".action = reset-window-height;
      "Mod+C".action = center-column;
      # "Mod+Z".action = center-column; # kinda like `zz` in helix
      "Mod+Z".action = spawn (pkgs.lib.getExe pkgs.woomer);

      # TODO: implement
      # "Mod+BackSpace".action = focus-last-window;

      # TODO: keybind to switch the windows between two outputs/monitors
    };
  # // focus-workspace-keybinds;

  # FIXME: does not load correctly
  # TODO: check it works correctly
  # TODO: do we need to load it manually or does `niri-flake` do it?
  # Used for Xwayland integration in `niri`
  # Copied from: https://github.com/Supreeeme/xwayland-satellite/blob/main/resources/xwayland-satellite.service
  # systemd.user.services.xwayland-satellite = {
  #   Unit = {
  #     Description = "Xwayland outside your Wayland";
  #     BindsTo = "graphical-session.target";
  #     PartOf = "graphical-session.target";
  #     After = "graphical-session.target";
  #     Requisite = "graphical-session.target";
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service = {
  #     Type = "notify";
  #     NotifyAccess = "all";
  #     ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
  #     StandardOutput = "journal";
  #   };
  # };

  # systemd.user.services.swww-daemon = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${inputs.swww.packages.${pkgs.system}.swww}/bin/swww-daemon";
  # };

  # systemd.user.services.copyq = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.copyq}/bin/copyq";
  # };

  # systemd.user.services.eww-daemon = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.eww}/bin/eww daemon";
  # };

  # https://haseebmajid.dev/posts/2023-07-25-nixos-kanshi-and-hyprland/
  # "eDP-1" is laptop screen
  services.kanshi = {
    enable = config.programs.niri.enable;
    # TODO: does this target exist?
    systemdTarget = "niri-session.target";
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
    ];
  };
}
