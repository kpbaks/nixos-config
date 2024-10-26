{ config, pkgs, ... }:
{

  # ref: https://pastebin.com/xycT4nrk
  services.swaync =
    let
      control-center-margin = 10;
    in
    {
      enable = true;
      settings = rec {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "overlay";
        layer-shell = true;
        notification-inline-replies = true;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        cssPriority = "application";
        control-center-margin-top = control-center-margin;
        control-center-margin-bottom = control-center-margin;
        control-center-margin-right = control-center-margin;
        control-center-margin-left = control-center-margin;
        notification-2fa-action = true;
        timeout = timeout-low + 1;
        timeout-low = 5;
        timeout-critical = 0;
        fit-to-screen = true;
        # control-center-width = 500;
        # control-center-height = 1025;
        # notification-window-width = 440;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = true;
        hide-on-action = true;
        script-fail-notify = true;
        widgets = [
          "title"
          "dnd"
          "notifications"
          "mpris"
          "volume"
          "buttons-grid"
        ];
        widget-config = {
          dnd.text = "Do Not Disturb";
          title = {
            text = "Notification Center";
            clear-all-button = true;
            button-text = "󰆴 Clear All";
          };
          label = {
            max-lines = 1;
            text = "Notification Center";
          };
          mpris = {
            image-size = 96;
            image-radius = 7;
          };
          volume = {
            label = "󰕾";
            show-per-app = true;
          };
          buttons-grid.actions =
            let
              systemctl = subcommand: "${pkgs.systemd}/bin/systemctl ${subcommand}";
              todo = "${pkgs.libnotify}/bin/notify-send 'home-manager' 'not implemented this action yet'";
            in
            [
              {
                label = "󰐥";
                command = systemctl "poweroff";
              }
              {
                label = "󰜉";
                command = systemctl "reboot";
              }
              {
                label = "󰌾";
                command = todo;
                # "command": "$HOME/.config/hypr/scripts/lock-session.sh"
              }
              {
                label = "󰍃";
                # command = "hyprctl dispatch exit";
                command = todo;
              }
              {
                label = "󰤄";
                command = systemctl "suspend";
              }
              {
                label = "󰕾";
                command = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
              }
              {
                label = "󰍬";
                command = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
              }
              {
                label = "󰖩";
                # command = "$HOME/.local/bin/shved/rofi-menus/wifi-menu.sh";
                command = todo;
              }
              {
                label = "󰂯";
                # command = "${pkgs.blueman}/bin/blueman-manager";
                command = "${pkgs.overskride}/bin/overskride";
              }
              {
                label = "";
                command = "${pkgs.obs-studio}/bin/obs";
              }
            ];
        };
        #     "buttons-grid": {
        #         "actions": [
        #             {
        #                 "label": "󰐥",
        #                 "command": "systemctl poweroff"
        #             },
        #             {
        #                 "label": "󰜉",
        #                 "command": "systemctl reboot"
        #             },
        #             {
        #                 "label": "󰌾",
        #                 "command": "$HOME/.config/hypr/scripts/lock-session.sh"
        #             },
        #             {
        #                 "label": "󰍃",
        #                 "command": "hyprctl dispatch exit"
        #             },
        #             {
        #                 "label": "󰤄",
        #                 "command": "systemctl suspend"
        #             },
        #             {
        #                 "label": "󰕾",
        #                 "command": "swayosd-client --output-volume mute-toggle"
        #             },
        #             {
        #                 "label": "󰍬",
        #                 "command": "swayosd-client --input-volume mute-toggle"
        #             },
        #             {
        #                 "label": "󰖩",
        #                 "command": "$HOME/.local/bin/shved/rofi-menus/wifi-menu.sh"
        #             },
        #             {
        #                 "label": "󰂯",
        #                 "command": "blueman-manager"
        #             },
        #             {
        #                 "label": "",
        #                 "command": "obs"
        #             }
        #         ]
        #     }
        # }
      };
      # TODO: improve layout
      # https://github.com/catppuccin/swaync
      # https://github.com/ErikReider/SwayNotificationCenter/discussions/183
      # https://github.com/rose-pine/swaync
      # TODO: inject catppuccin colors by prepending each color with `@define-color`
      # style = builtins.readFile ./style.css;
      style = builtins.readFile ./macchiato.css;
    };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Shift+N".action = spawn "${pkgs.swaynotificationcenter}/bin/swaync-client" "--toggle-panel";
  };
}
