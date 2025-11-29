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
  ];

  programs.noctalia-shell = {
    enable = true;
    # TODO: limit to only use niris activation target
    systemd.enable = true;
    # https://docs.noctalia.dev/getting-started/nixos/#config-ref
    settings = {
      bar = { };
      hooks.enabled = false;
      nightLight = {
        enabled = true;
      };
    };
  };

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
      {
        matches = [
          {
            namespace = "^quickshell-wallpaper$";
          }
        ];
      }
      {
        matches = [
          {
            namespace = "^quickshell-overview$";

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
  services.darkman = {
    darkModeScripts = {
      noctalia-dark-mode = ''${lib.getExe noctalia-shell} ipc call darkMode setDark'';
    };
    lightModeScripts = {
      noctalia-light-mode = ''${lib.getExe noctalia-shell} ipc call darkMode setLight'';
    };
  };
}
