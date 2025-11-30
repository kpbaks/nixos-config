{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  noctalia-shell = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    inputs.noctalia.homeModules.default
    ./app-theming.nix
  ];

  programs.noctalia-shell = {
    enable = true;
    # TODO: limit to only use niris activation target
    systemd.enable = true;
    # https://docs.noctalia.dev/getting-started/nixos/#config-ref
    settings = {
      osd = {
        enabled = true;
        location = "top_center";
        enabledTypes = [
          0
          1
          2
          3
        ];
      };
      bar = {
        density = "comfortable";
        position = "right";
        floating = true;
        widgets = {
          left = [
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveMonitor";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              characterCount = 2;
              followFocusedScreen = false;
              hideUnoccupied = true;
              labelMode = "index+name";
            }
          ];
          right = [
            {
              id = "ScreenRecorder";
            }
            {
              id = "Tray";
              blacklist = [ "udiskie" ];
              pinned = [ "Telegram Desktop" ];
              colorizeIcons = false;
              drawerEnabled = false;
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "KeyboardLayout";
              displayMode = "alwaysShow";
            }
            {
              id = "Bluetooth";
              displayMode = "alwaysShow";
            }
            {
              id = "WiFi";
              displayMode = "alwaysShow";
            }
            {
              id = "Battery";
              displayMode = "alwaysShow";
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
            }
            {
              id = "Brightness";
              displayMode = "alwaysShow";
            }
            {
              id = "DarkMode";
            }
            {
              id = "Clock";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };
      dock.enabled = false;
      hooks = {
        enabled = true;
        darkModeChange =
          let
            darkman = lib.getExe config.services.darkman.package;
            script = pkgs.writeShellScriptBin "darkModeChange" ''${darkman} set $([ $1 = "true" ] && echo dark || echo light)'';
          in
          script;
      };
      nightLight = {
        enabled = true;
      };
      location = {
        name = "Aarhus";
        showWeekNumberInCalendar = true;
        analogClockInCalendar = true;
      };
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = true;
      };
      notifications = {
        respectExpireTimeout = true;
      };

      colorSchemes = {
        useWallpaperColors = false;
        # predefinedScheme = "Noctalia (default)";
        predefinedScheme = "Nord";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };

      templates = {
        gtk = true;
        qt = true;
        kcolorscheme = false;
        alacritty = false;
        kitty = false;
        ghostty = false;
        foot = false;
        wezterm = false;
        fuzzel = false;
        discord = false;
        pywalfox = false;
        vicinae = true;
        walker = false;
        code = false;
        spicetify = true;
        telegram = true;
        cava = false;
        enableUserTemplates = false;
      };

      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "${config.home.homeDirectory}/Pictures/wallpapers";
      };
    };
  };

  #   // Set the overview wallpaper on the backdrop.
  # layer-rule {
  #   match namespace="^noctalia-overview*"
  #   place-within-backdrop true
  # }

  programs.niri.settings = {
    window-rules = [
      {
        geometry-corner-radius =
          let
            r = 12.0;
          in
          {
            bottom-right = r;
            bottom-left = r;
            top-right = r;
            top-left = r;
          };
        clip-to-geometry = true;
      }
    ];
    layer-rules = [
      # {
      #   matches = [
      #     {
      #       namespace = "^noctalia-wallpaper$";
      #     }
      #   ];
      # }
      {
        matches = [
          {
            namespace = "^noctalia-overview*";
          }
        ];
        place-within-backdrop = true;
      }
    ];
    spawn-at-startup = [
      {
        command = [ (lib.getExe noctalia-shell) ];
      }
    ];
    binds =
      with config.lib.niri.actions;
      let
        inherit (lib) mkForce;
        ipc = spawn (lib.getExe noctalia-shell) "ipc" "call";
        toggle-settings-menu = {
          action = ipc "settings" "toggle";
          hotkey-overlay.title = "Toggle Settings Menu";
          repeat = false;
        };
        lockscreen = {
          action = ipc "lockScreen" "lock";
          hotkey-overlay.title = "Toggle Lockscreen";
          repeat = false;
        };
        toggle-wallpaper-menu = {
          action = ipc "wallpaper" "toggle";
          hotkey-overlay.title = "Toggle Wallpaper Menu";
          repeat = false;
        };
        monitor-brightness = delta: {
          action = ipc "brightness" delta;
          # TODO: upcase delta
          hotkey-overlay.title = "${delta} Monitor Brightness";
        };
        audio-volume = delta: {
          action = ipc "volume" delta;
          # TODO: upcase delta
          hotkey-overlay.title = "${delta} Audio Volume";
        };
        toggle-audio-mute = {
          action = ipc "volume" "muteOutput";
          hotkey-overlay.title = "Mute/Unmute Audio Output";
        };
      in
      {
        "Mod+Comma" = toggle-settings-menu;
        "Mod+I" = toggle-settings-menu; # Like on Windows
        # "Mod+Shift+L" = lockscreen;
        "Mod+W" = toggle-wallpaper-menu;
        "XF86MonBrightnessUp" = mkForce (monitor-brightness "increase");
        "XF86MonBrightnessDown" = mkForce (monitor-brightness "decrease");
        "XF86AudioRaiseVolume" = mkForce (audio-volume "increase");
        "XF86AudioLowerVolume" = mkForce (audio-volume "decrease");
        "XF86AudioMute" = mkForce toggle-audio-mute;
        # "Mod+V" = {
        #   action = ipc "launcher" "clipboard";
        #   hotkey-overlay.title = "Open Clipboard History Menu";
        #   repeat = false;
        # };

      };
  };

  # TODO: add this snippet to https://docs.noctalia.dev/
  # https://docs.noctalia.dev/getting-started/keybinds/#theme-controls
  # services.darkman = {
  #   darkModeScripts = {
  #     noctalia-dark-mode = ''${lib.getExe noctalia-shell} ipc call darkMode setDark'';
  #   };
  #   lightModeScripts = {
  #     noctalia-light-mode = ''${lib.getExe noctalia-shell} ipc call darkMode setLight'';
  #   };
  # };
}
