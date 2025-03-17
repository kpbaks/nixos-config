# https://alacritty.org/config-alacritty.html
{ lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      bell.duration = 200;
      cursor = {
        style = {
          blinking = "On";
          shape = "Beam";
        };
        blink_interval = 750; # ms
        unfocused_hollow = true;
      };
      font = {
        builtin_box_drawing = true;
        normal = {
          # family = "JetBrains Mono NFM";
          # family = "Iosevka Nerd Font Mono";
          style = "Regular";
        };
        # size = 16;
      };
      mouse.hide_when_typing = true;
      hints.enabled = [
        {
          command = "${lib.getExe pkgs.handlr}";
          hyperlinks = true;
          post_processing = true;
          persist = false;
          # "mouse.enabled" = true;
          binding = {
            key = "u";
            mods = "Control|Shift";
          };
        }
      ];
      keyboard.bindings =
        let
          ctrl = "Control";
          super = "Super";
          shift = "Shift";
          alt = "Alt";
          mods = modifiers: builtins.concatStringsSep "|" modifiers;

          as-kv = value: { "${value}" = value; };
          merge = list: builtins.foldl' (acc: it: acc // it) { } list;
          actions = merge (

            map as-kv [
              "SearchForward"
              "CreateNewWindow"
            ]
          );
          bind = mods': key: action: {
            inherit key action;
            mods = mods mods';
          };
        in
        [
          # {
          #   key = "f";
          #   mods = mods [ctrl shift];
          #   action = "SearchForward";
          #   # SearchBackward
          # }
          # (bind [ctrl shift] "t" "CreateNewTab")
          (bind [
            ctrl
            shift
          ] "f" actions.SearchForward)
          # (bind [ctrl shift] "n" "CreateNewWindow")
          # {
          #   key = "n";
          #   bind = bind [ctrl shift];
          #   chars = "n";
          # }
          (bind [ shift ] "Escape" "ToggleViMode")
        ];
      general.live_config_reload = true;
      general.ipc_socket = true;
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      selection.save_to_clipboard = true;
      window = {
        blur = false;
        decorations = "None";
        dynamic_padding = true;
        opacity = 1.0;
        padding = {
          x = 10;
          y = 10;
        };
        # startup_mode = "Fullscreen";
      };
    };
  };

}
