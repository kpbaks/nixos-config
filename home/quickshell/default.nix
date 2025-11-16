# https://quickshell.outfoxxed.me/
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # https://github.com/nix-community/nixGL#usage
  # FIXME: make it work without this fix
  # noctalia-shell = pkgs.writeShellScriptBin "noctalia-shell" ''
  #   ${lib.getExe pkgs.nixgl.nixGLIntel} ${lib.getExe inputs.noctalia.packages.${pkgs.system}.default}
  # '';
  noctalia-shell = inputs.noctalia.packages.${pkgs.system}.default;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # TODO: change to use this module for config
  # programs.noctalia-shell = {
  #   enable = true;
  #   # https://docs.noctalia.dev/getting-started/nixos/#systemd-service
  #   systemd.enable = false; # experimental feature
  #   settings = {

  #   };
  # };

  # FIXME: why are these not in $PATH $out/bin/{qs,quickshell}
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
    # (inputs.quickshell.packages.${pkgs.system}.default.override {
    #   withJemalloc = true;
    #   withQtSvg = true;
    #   withWayland = true;
    #   withX11 = false;
    #   withPipewire = true;
    #   withPam = true;
    #   withHyprland = false;
    # })

    pkgs.kdePackages.qtdeclarative # for `qmlformat`, `qmllint`, `qmlls`
    noctalia-shell
  ];

  # https://github.com/noctalia-dev/noctalia-shell#recommended-compositor-settings
  programs.niri = {
    settings = {
      debug = {
        # FIXME: github:sodiboo/niri-flake does not have support for this option
        # honor-xdg-activation-with-invalid-serial = true;
      };

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
      binds =
        with config.lib.niri.actions;
        let
          ipc = spawn (lib.getExe noctalia-shell) "ipc" "call";
          toggle-settings-menu = {
            action = ipc "settings" "toggle";
            hotkey-overlay.title = "Toggle Settings Menu";
            repeat = false;
          };
        in
        {
          "Mod+Comma" = toggle-settings-menu;
          "Mod+I" = toggle-settings-menu; # Like on Windows
          # "Mod+Slash" = {
          #   action = ipc "launcher" "toggle";
          #   hotkey-overlay.title = "Toggle Application Launcher";
          #   repeat = false;
          # };
          # TODO: bind to an action that toggles light/dark theme
          # hint: it is the f12 key with a shaded moon on it
          "XF86Sleep" = {
            action = ipc "darkMode" "toggle";
            hotkey-overlay.title = "Toggle Dark Mode";
            repeat = false;
          };
          # "Mod+V" = {
          #   action = ipc "launcher" "clipboard";
          #   hotkey-overlay.title = "Open Clipboard History Menu";
          #   repeat = false;
          # };
          "Mod+L" = {
            action = ipc "lockScreen" "lock";
            hotkey-overlay.title = "Toggle Lockscreen";
            repeat = false;
          };
          "Mod+W" = {
            action = ipc "wallpaper" "toggle";
            hotkey-overlay.title = "Toggle Wallpaper Menu";
            repeat = false;
          };
          # "Control+Alt+Delete" = {
          #   action = ipc "sessionMenu" "toggle";
          #   hotkey-overlay.title = "Toggle Logout, Shutdown, Reboot etc. Menu";
          #   repeat = false;
          # };

          "XF86MonBrightnessUp" = {
            action = ipc "brightness" "increase";
            hotkey-overlay.title = "Increase Monitor Brightness";
          };
          "XF86MonBrightnessDown" = {
            action = ipc "brightness" "decrease";
            hotkey-overlay.title = "Decrease Monitor Brightness";
          };
        };
      spawn-at-startup = [
        {
          command = [ (lib.getExe noctalia-shell) ];
        }
      ];
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
