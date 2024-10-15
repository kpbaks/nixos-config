{
  config,
  lib,
  pkgs,
  ...
}:
{

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

      # Mod+Ctrl+Shift+N { spawn "/home/myname/scripts/niri_win.sh" "goto" "org.wezfurlong.wezterm" "/home/myname/bin/wezterm --config enable_wayland=true"; }
      # Mod+Ctrl+Shift+E { spawn "/home/myname/scripts/niri_win.sh" "goto" "code-url-handler" "/usr/share/code/code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto --unity-launch"; }
      # Mod+Ctrl+Shift+I { spawn "/home/myname/scripts/niri_win.sh" "goto" "vivaldi-stable" "/usr/bin/vivaldi-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"; }

      # TODO: limit to current workspace, or screen by using the output for `niri msg --json workspaces`
      focus-to-spawn-script =
        let
          niri = "${config.programs.niri.package}/bin/niri";
        in
        pkgs.writers.writeNuBin "niri-spawn-or-focus" { }
          # nushell
          ''
            def main [app_id: string, program: string] {
              let windows = ${niri} msg --json windows | from json
              # let workspaces = ${niri} msg --json workspaces | from json

              let focus = $windows
              | filter { |window| $window.app_id == $app_id }
              | length
              | do { $in > 0 }

              if $focus {
                ${pkgs.wlrctl}/bin/wlrctl window focus $app_id
              } else {
                ${niri} msg action spawn -- $program
              }
            }
          '';
      focus-or-spawn = spawn (lib.getExe focus-to-spawn-script);
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
      # "Mod+T".action = spawn terminal;
      "Mod+T".action = focus-or-spawn "foot" "${pkgs.foot}/bin/foot";
      # "Mod+Y".action = focus-or-spawn "foot" "${pkgs.foot}/bin/foot";

      "Mod+Shift+T".action = spawn terminal "${pkgs.fish}/bin/fish" "--private";
      # "Mod+F".action = spawn "firefox";
      # "Mod+Shift+F".action = spawn "firefox" "--private-window";
      # "Mod+F".action = browser;

      # run-flatpak = spawn "flatpak" "run";
      # # browser = spawn "${pkgs.firefox}/bin/firefox";
      # browser = run-flatpak "io.github.zen_browser.zen";
      # # run-in-terminal = spawn "kitty";
      "Mod+F".action = focus-or-spawn "zen-alpha" "flatpak run io.github.zen_browser.zen";
      # "Mod+Shift+F".action = browser "--private-window";
      # "Mod+G".action = spawn "telegram-desktop";
      "Mod+G".action = focus-or-spawn "org.telegram.desktop" "${pkgs.telegram-desktop}/bin/telegram-desktop";
      "Mod+S".action = spawn "spotify";
      # "Mod+D".action = spawn "webcord";
      # "Mod+D".action = spawn "vesktop";
      # D for discord
      "Mod+D".action = focus-or-spawn "vesktop" "${pkgs.vesktop}/bin/vesktop";
      # N for notes
      "Mod+N".action = focus-or-spawn "Logseq" "${pkgs.logseq}/bin/logseq";
      # "Mod+E".action = run-in-kitty "yazi";
      # TODO: detect the newest file in ~/Downloads and focus it first by doing `yazi $file`
      "Mod+Y".action = run-with-sh-within-terminal "cd ~/Downloads; yazi";
      # E is default on other platforms like Windows, for opening the "file explorer" program
      "Mod+E".action = focus-or-spawn "org.kde.dolphin" "${pkgs.kdePackages.dolphin}/bin/dolphin";
      # "Mod+E".action = spawn "dolphin";
      # "Mod+B".action = spawn "overskride";
      # "Mod+B".action = run-in-terminal (pkgs.lib.getExe scripts.bluetoothctl-startup);
      # "Mod+A".action = run-in-terminal (pkgs.lib.getExe scripts.audio-sink);

      # FIXME: does not work
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
      # "Mod+Y".action = browser "https://youtube.com";

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
      "Mod+Shift+M".action = maximize-column;

      # "Mod+K".action = spawn "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-app";
      "Mod+K".action = focus-or-spawn "org.kde.kdeconnect.app" "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-app";

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
      # "Mod+Comma".action = run-with-fish-within-terminal "hx ~/dotfiles/{flake,configuration}.nix";
      # "Mod+Period".action = spawn "${pkgs.swaynotificationcenter}/bin/swaync-client" "--toggle-panel";
      "Mod+Period".action = focus-or-spawn "org.kde.plasma.emojier" "${pkgs.plasma-desktop}/bin/plasma-emojier";
      # TODO: color picker keybind

      "Mod+M".action = focus-or-spawn "thunderbird" "${pkgs.thunderbird}/bin/thunderbird";

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
      "Mod+Slash".action = spawn "${pkgs.walker}/bin/walker";

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
  # // focus-workspace-keybinds;}
}
