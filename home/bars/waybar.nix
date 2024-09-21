{
  config,
  pkgs,
  ...
}:
let

  # TODO: present more nicely maybe with the `tabulate` package
  scripts.wb-reload = pkgs.writers.writeBashBin "wb-reload" ''
    if ! ${pkgs.procps}/bin/pkill -USR2 waybar; then
      ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
      ${pkgs.waybar}/bin/waybar 2>/dev/null >&2 &; disown
    fi
  '';

  scripts.wb-toggle-visibility = pkgs.writers.writeBashBin "wb-toggle-visibility" ''
    if ! ${pkgs.procps}/bin/pkill -USR1 waybar; then
      # ${pkgs.libnotify}/bin/notify-send --transient --category= "waybar" "waybar is not running"
      ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
    fi
  '';

  scripts.wb-toggle-visibility-or-spawn =
    pkgs.writers.writeFishBin "waybar.toggle-visibility-or-spawn" { }
      # fish
      ''
        set -l waybar_pids (${pkgs.procps}/bin/pgrep waybar)

        ${pkgs.procps}/bin/pkill -USR1 waybar; and return

        # Check if waybar is installed as a systemd service
        for scope in "" --user
          ${pkgs.systemd}/bin/systemctl $scope status waybar.service
          switch $status
            case 3 # Exists but is not running
              # TODO: there is a chance it is not enabled
              ${pkgs.systemd}/bin/systemctl $scope start waybar.service
              return
            case 4 # Does not exist
          end
        end

        # ${pkgs.waybar}/bin/waybar 
        ${pkgs.waybar}/bin/waybar 2>/dev/null >&2 &; disown
        # end
          # if ! ${pkgs.procps}/bin/pkill -USR1 waybar; then
          #   # ${pkgs.libnotify}/bin/notify-send --transient --category= "waybar" "waybar is not running"
          #   ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
          # fi
      '';

  scripts.wb-watch-config-and-reload = pkgs.writers.writeBashBin "wb-watch-config-and-reload" ''
    if ${pkgs.procps}/bin/pgrep waybar; then
      ${pkgs.watchexec}/bin/watchexec --watch ${config.home.homeDirectory}/.config/waybar ${pkgs.lib.getExe scripts.wb-reload}
    else
      ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
    fi
  '';
in

{

  # home.file.".config/waybar/nix-logo.png".source = ./nix-logo.png;
  # xdg.configFile."waybar-nixos-logo.png".source = ./nixos-logo.png;

  # TODO: use https://github.com/raffaem/waybar-mediaplayer
  # https://github.com/raffaem/waybar-screenrecorder
  programs.waybar = {
    enable = false;
    # catppuccin.enable = false;
    catppuccin.mode = "prependImport";
    # FIXME: does not start with `niri`
    # TODO: change service to only activate if target is niri, and not apply on kde aswell
    systemd.enable = true;
    settings =
      let
        height = 48;
        states = {
          warning = 80;
          critical = 95;
        };
      in
      {
        topbar = {
          layer = "top";
          position = "top";

          spacing = 4; # px
          # inherit height;
          # TODO: see if there is a way to only use external monitors when there are multiple and, still be able to use the laptop when no extra is connected.
          # output = builtins.attrValues monitors;
          modules-left = [
            "mpris"
            # "cava"
          ];
          modules-center = [ "wlr/taskbar" ];
          modules-right = [
            "tray"
            # "image#nixos-logo"
          ];

          "wlr/taskbar" = {
            all-outputs = true;
            icon-size = 24;
            # "format"= "{icon} {title} {short_state}";
            format = "{icon}";
            tooltip-format = "{title} | {app_id}";
            on-click = "activate";
            on-click-middle = "close";
            on-click-right = "fullscreen";
          };

          mpris = {
            # "format"= "{player_icon}  <b>{dynamic}</b>";
            # "format-paused"= "{status_icon}  <i>{dynamic}</i>";
            format = "{player_icon}  <b>{title} - {artist} - ({length})</b>";
            format-paused = "{player_icon}  <i>{title} - {artist} - ({length})</i>";
            player-icons = {
              default = "▶";
              mpv = "🎵";
              spotify = "";
              youtube = "";
            };
            status-icons = {
              paused = "⏸";
              playing = "▶";
            };
            # "ignored-players"= ["firefox"]
          };

          tray = {
            icon-size = 24;
            spacing = 16;
          };
        };
        # leftbar = {
        #   layer = "top";
        #   position = "right";

        #   spacing = 4; # px
        #   inherit height;
        #   output = builtins.attrValues monitors;
        #   modules-left = [
        #     # "cava"
        #   ];
        #   modules-center = [ "wlr/taskbar" ];
        #   modules-right = [
        #     # "image#nixos-logo"
        #   ];

        #   # "image#nixos-logo" = {
        #   #   path = home.homeDirectory + "/.config/waybar/nixos-logo.png";
        #   #   size = 32;
        #   #   # interval = 60 * 60 * 24;
        #   #   on-click = "${pkgs.xdg-utils}/bin/xdg-open 'https://nixos.org/'";
        #   #   tooltip = true;
        #   # };

        #   "wlr/taskbar" = {
        #     all-outputs = true;
        #     # "format"= "{icon} {title} {short_state}";
        #     format = "{icon}";
        #     tooltip-format = "{title} | {app_id}";
        #     on-click = "activate";
        #     on-click-middle = "close";
        #     on-click-right = "fullscreen";
        #   };

        #   cava = {
        #     # //        "cava_config": "$XDG_CONFIG_HOME/cava/cava.conf",
        #     # cava_config = config.home.homeDirectory + ".config/cava/config";
        #     framerate = 30;
        #     autosens = 1;
        #     # sensitivity = 100;
        #     bars = 14;
        #     lower_cutoff_freq = 50;
        #     higher_cutoff_freq = 10000;
        #     hide_on_silence = true;
        #     method = "pulse";
        #     source = "auto";
        #     stereo = true;
        #     reverse = false;
        #     bar_delimiter = 0;
        #     monstercat = true;
        #     waves = false;
        #     noise_reduction = 0.77;
        #     input_delay = 2;
        #     format-icons = [
        #       "▁"
        #       "▂"
        #       "▃"
        #       "▄"
        #       "▅"
        #       "▆"
        #       "▇"
        #       "█"
        #     ];
        #     actions = {
        #       on-click-right = "mode";
        #     };
        #   };
        # };
        bottombar = {
          layer = "top";
          position = "bottom";
          spacing = 4; # px
          # inherit height;
          # output = builtins.attrValues monitors;
          # margin-top = 5;
          # margin-bottom = 5;
          modules-left = [
            # "systemd-failed-units"
            # "keyboard-state"
            # "image#nixos-logo"
            # "backlight"
            "backlight/slider"
            "pulseaudio"
            # "wireplumber"
            "pulseaudio/slider"
            # "mpris"
            # "image/spotify-cover-art"
            # "cava"
            # "cava" # FIXME: get to work
          ];
          modules-center = [
            # "wlr/taskbar"
            "systemd-failed-units"
            # "tray"
            "privacy"
            "clock"
            "custom/weather"
          ];
          modules-right = [
            "power-profiles-daemon"
            # "idle_inhibitor"
            "battery"
            "disk"
            "memory"
            # "load"
            "cpu"
            # "custom/gpu-usage"
            "temperature"
            "bluetooth"
            "network"
            "custom/notification"
          ];

          "custom/weather" = {
            format = "{}";
            tooltip = true;
            interval = 3600;
            exec = "${pkgs.wttrbar}/bin/wttrbar";
            return-type = "json";
          };

          # TODO: use and customize
          # https://gist.github.com/MyrikLD/4467d4dae3f0911cd5094b8440cbf418
          # "custom/external-monitor-brightness" = {
          #   format = "{icon} {percentage}%";
          #   format-icons = [
          #     "\uDB80\uDCDE"
          #     "\uDB80\uDCDF"
          #     "\uDB80\uDCE0"
          #   ];
          #   return-type = "json";
          #   exec = "ddcutil --bus 7 getvcp 10 | grep -oP 'current.*?=\\s*\\K[0-9]+' | { read x; echo '{\"percentage\"='${x}'}'; }";
          #   on-scroll-up = "ddcutil --noverify --bus 7 setvcp 10 + 10";
          #   on-scroll-down = "ddcutil --noverify --bus 7 setvcp 10 - 10";
          #   on-click = "ddcutil --noverify --bus 7 setvcp 10 0";
          #   on-click-right = "ddcutil --noverify --bus 7 setvcp 10 100";
          #   interval = 1;
          #   tooltip = false;
          # };

          "backlight/slider" = {
            min = 0;
            max = 100;
            orientation = "horizontal";
            device = "intel_backlight";
          };

          "pulseaudio/slider" = {
            min = 0;
            max = 100;
            orientation = "horizontal";
          };
          battery = {
            format = "{capacity}% {icon} ";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          bluetooth = {
            format = " {status}";
            format-connected = " {device_alias}";
            format-connected-battery = " {device_alias} {device_battery_percentage}%";
            # "format-device-preference"= [ "device1"; "device2" ]; // preference list deciding the displayed device
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            on-click = pkgs.lib.getExe scripts.bluetoothctl-startup;
            # on-click = "${pkgs.bluez}/bin/bluetoothctl "
          };

          cava = {
            # //        "cava_config": "$XDG_CONFIG_HOME/cava/cava.conf",
            # cava_config = config.home.homeDirectory + ".config/cava/config";
            framerate = 30;
            autosens = 1;
            # sensitivity = 100;
            bars = 14;
            lower_cutoff_freq = 50;
            higher_cutoff_freq = 10000;
            hide_on_silence = true;
            method = "pulse";
            source = "auto";
            stereo = true;
            reverse = false;
            bar_delimiter = 0;
            monstercat = true;
            waves = false;
            noise_reduction = 0.77;
            input_delay = 2;
            format-icons = [
              "▁"
              "▂"
              "▃"
              "▄"
              "▅"
              "▆"
              "▇"
              "█"
            ];
            actions = {
              on-click-right = "mode";
            };
          };

          memory = {
            interval = 10;
            # format = "{used:0.1f}GiB / {total:0.1f}GiB  ";
            format = "{percentage}% used {avail:0.1f}GiB  ";
            on-click = "${pkgs.lib.getExe config.default-application.terminal} ${pkgs.lib.getExe pkgs.btop}";
            states = {
              warning = 70; # percent
              critical = 95; # percent
            };
          };
          # TODO: add `on-click` that either opens `systemctl-tui` or a script that filters out the failed units to show
          systemd-failed-units = {
            hide-on-ok = true;
            format = "systemd ✗ {nr_failed}";
            format-ok = "✓";
            system = true;
            user = true;
            on-click = "${pkgs.lib.getExe scripts.systemd-failed-units}";

            # on-click 
          };
          clock = {
            interval = 60;
            format = "{:%H:%M} ";
            format-alt = "{:%A; %B %d; %Y (%R)}  ";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            on-click = "${pkgs.thunderbird}/bin/thunderbird -calendar";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              # TODO: change colors to catppuccin
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          pulseaudio = {
            format = "{volume}% {icon} ";
            format-bluetooth = "{volume}% {icon}  ";
            format-muted = "";
            format-icons = {
              # "alsa_output.pci-0000_00_1f.3.analog-stereo"= "";
              # "alsa_output.pci-0000_00_1f.3.analog-stereo-muted"= "";
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
              ];
            };
            scroll-step = 1;
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            ignored-sinks = [ "Easy Effects Sink" ];
          };
          wireplumber = {
            format = "{volume}% {icon}";
            format-muted = "";
            on-click = "${pkgs.helvum}/bin/helvum";
            format-icons = [
              ""
              ""
              ""
            ];
          };

          # TODO: add upload/download metrics
          network = {
            # "interface"= "wlp2s0";
            format = "{ifname}";
            format-wifi = "{essid} ({signalStrength}%)  ";
            format-ethernet = "{ipaddr}/{cidr} 󰊗 ";
            format-disconnected = ""; # An empty format will hide the module.
            tooltip-format = "{ifname} via {gwaddr} 󰊗 ";
            tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
            tooltip-format-ethernet = "{ifname}  ";
            tooltip-format-disconnected = "Disconnected";
            # max-length = 50;
            # on-click = "nmtui";
            on-click = "${pkgs.lib.getExe config.default-application.terminal} ${pkgs.networkmanager}/bin/nmtui";
          };

          power-profiles-daemon = {
            format = "{icon}   {profile}";
            tooltip-format = "Power profile = {profile}\nDriver = {driver}";
            tooltip = true;
            format-icons = {
              default = "";
              performance = "";
              balanced = "";
              power-saver = "";
            };
          };

          cpu = {
            inherit states;
            interval = 5;
            tooltip = true;
            on-click = "${pkgs.lib.getExe config.default-application.terminal} ${pkgs.lib.getExe pkgs.btop}";
            format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7} {}%  ";
            # TODO: change colors to catppuccin
            format-icons =
              let
                catppuccin-color =
                  name:
                  let
                    hex = config.flavor.${name}.hex;
                  in
                  hex;
              in
              [
                "<span color='${catppuccin-color "green"}'>▁</span>" # green
                "<span color='${catppuccin-color "blue"}'>▂</span>" # blue
                "<span color='${catppuccin-color "sky"}'>▃</span>" # white
                "<span color='${catppuccin-color "sapphire"}'>▄</span>" # white
                "<span color='${catppuccin-color "yellow"}'>▅</span>" # yellow
                "<span color='${catppuccin-color "peach"}'>▆</span>" # yellow
                "<span color='${catppuccin-color "maroon"}'>▇</span>" # orange
                "<span color='${catppuccin-color "red"}'>█</span>" # red
                # "<span color='#69ff94'>▁</span>" # green
                # "<span color='#2aa9ff'>▂</span>" # blue
                # "<span color='#f8f8f2'>▃</span>" # white
                # "<span color='#f8f8f2'>▄</span>" # white
                # "<span color='#ffffa5'>▅</span>" # yellow
                # "<span color='#ffffa5'>▆</span>" # yellow
                # "<span color='#ff9977'>▇</span>" # orange
                # "<span color='#dd532e'>█</span>" # red
              ];

            # colors =
            #   let
            #     hex2fuzzel-color = hex: "${builtins.substring 1 6 hex}ff";
            #     catppuccin2fuzzel-color = name: hex2fuzzel-color palette.catppuccin.${name}.hex;
            #   in
            #   builtins.mapAttrs (_: color: catppuccin2fuzzel-color color) {
            #     background = "surface0";
            #     text = "text";
            #     match = "mauve";
            #     selection = "overlay0";
            #     selection-text = "text";
            #     selection-match = "pink"#pulseaudio.bluetooth;
            #     border = "blue";
            #   };
          };

          privacy = {
            icon-spacing = 4;
            icon-size = 18;
            transition-duration = 250;
            modules = [
              {
                type = "screenshare";
                tooltip = true;
                tooltip-icon-size = 24;
              }
              {
                type = "audio-out";
                tooltip = true;
                tooltip-icon-size = 24;
              }
              {
                type = "audio-in";
                tooltip = true;
                tooltip-icon-size = 24;
              }
            ];
          };

          temperature = {
            # thermal-zone = 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            # critical-threshold = 80;
            # format-critical = "{temperatureC}°C ";
            format = "{temperatureC}°C ";
          };

          # "disk": {
          #   // "format": "   {used} / {total}",
          #   "format": "   {percentage_used}% used {free} free",
          #   "states": {
          #     "warning": 80,
          #     "critical": 95
          #   },

          #   "interval": 600,
          #   "path": "/",
          #   // "unit": "GB"
          # },
          # // "height": 48,

          disk = {
            interval = 600;
            format = "   {percentage_used}% used {free} free";
            path = "/";
            unit = "GB";
            states = {
              warning = 80;
              critical = 95;
            };
          };
          # https=//www.nerdfonts.com/cheat-sheet?q=moon
          backlight = {
            device = "intel_backlight";
            format = "{percent}% {icon}";
            # FIXME: 30% looks weird
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };

          # FIXME: still not work
          "image/spotify-cover-art" = {
            # TODO
            exec = pkgs.lib.getExe scripts.spotify-cover-art;
            # exec = "spotify-cover-art";
            # "exec"= "bash -c 'spotify-cover-art'";
            # // "exec"="~/.config/waybar/custom/spotify/album_art.sh";
            size = height;
            interval = 30;
          };

          "custom/notification" = {
            tooltip = false;
            format = "{} {icon}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };

            return-type = "json";
            escape = true;
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          };

          #         "custom/notification": {
          #   "tooltip": false,
          #   "format": "{icon}",
          #   "format-icons": {
          #     "notification": "<span foreground='red'><sup></sup></span>",
          #     "none": "",
          #     "dnd-notification": "<span foreground='red'><sup></sup></span>",
          #     "dnd-none": "",
          #     "inhibited-notification": "<span foreground='red'><sup></sup></span>",
          #     "inhibited-none": "",
          #     "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
          #     "dnd-inhibited-none": ""
          #   },
          #   "return-type": "json",
          #   "exec-if": "which swaync-client",
          #   "exec": "swaync-client -swb",
          #   "on-click": "swaync-client -t -sw",
          #   "on-click-right": "swaync-client -d -sw",
          #   "escape": true
          # },

          # "group/group-power" = {
          #   orientation = "inerit";
          #   drawer = {
          #     transition-duration = 500;
          #     children-class = "not-power";
          #     transition-left-to-right = false;
          #   };
          #   modules = [
          #     "custom/power"
          #     "custom/quit"
          #     "custom/lock"
          #     "custom/reboot"
          #   ];
          # };

          # "custom/quit" = {
          #   format = "󰗼";
          #   tooltip = false;
          #   on-click = "hyprctl dispatch exit";
          # };
          # "custom/lock" = {
          #   format = "󰍁";
          #   tooltip = false;
          #   on-click = "swaylock";
          # };
          # "custom/reboot" = {
          #   format = "󰜉";
          #   tooltip = false;
          #   on-click = "systemctl reboot";
          # };

          # "custom/power" = {
          #   format = "";
          #   tooltip = false;
          #   on-click = "shutdown now";
          # };Job	Group	CPU	State	Command
          "image#nixos-logo" = {
            path = config.home.homeDirectory + "/.config/waybar/nixos-logo.png";
            size = 32;
            # interval = 60 * 60 * 24;
            on-click = "${pkgs.xdg-utils}/bin/xdg-open 'https://nixos.org/'";
            tooltip = true;
          };
        };
      };
    style =
      let
        bluetooth-blue = "#0082FC";
      in
      # css
      ''
        * {
            border: red;
            /* border-radius: 5px; */
            font-family: Roboto, Helvetica, Arial, sans-serif;
            font-size: 14px;
            font-weight: 600;
            /* min-height: 0; */
        }

        box.module button:hover {
            box-shadow: inset 0 -3px #ffffff;
            border: 2px solid red;
        }

        window#waybar {
            border-radius: 5px;
            /* background: rgba(43, 48, 59, 0.5); */
            /* background: alpha(@crust, 0.9); */
            background: @crust;
            margin: 10px 10px;
            padding: 10px 10px;
            /* border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
            /* border-top: 3px solid rgba(100, 114, 125, 0.5); */
            color: @text;
        }                        

        window#waybar.top {
            /* background: transparent; */
            border: 2px solid @surface0;
            /* box-shadow: inset 0 -3px; */
        }

        window#waybar.bottom {
            /* border-top: 2px solid @base; */

            /* border: 2px solid alpha(@teal, 0.75); */
            /* border: 2px solid alpha(@text, 0.25); */
            border: 2px solid @surface0;
        }

        /* window#waybar { */
            /* font-family: FontAwesome, monospace; */
            /* background-color: transparent; */
            /* border-bottom: 50px; */
            /* color: #ebdbb2; */
            /* transition-property: background-color; */
            /* transition-duration: .5s; */
        /* } */

        window#waybar.hidden {
            opacity: 0.2;
        }

        window#waybar.empty #window {
            background-color: transparent;
        }

        .modules-left, .modules-center, .modules-right {
            background-color: @base;
            border: 2px solid @surface1;
            margin: 6px 6px 6px 6px;
            padding: 0px 8px;
            border-radius: 5px;
            /* outline-color: red; */
        }

        .modules-left.empty {
            background-color: blue;
        }

        .modules-right {
            /* margin: 0px 4px 0 0; */
            /* background-color: red; */
            /* border-color: green; */
        }
        .modules-center {
            /* margin: 0px 8px; */
            /* background-color: blue; */
        }
        .modules-left {
            margin: 6px 6px 6px 6px;
            padding: 0px 8px;
            border-radius: 5px;
            /* background-color: @base; */
        }

        button {
            /* border: none; */
        }

        #tray menu {
            font-family: sans-serif;
        }

        tooltip {
          background: rgba(43, 48, 59, 0.5);
          border: 1px solid rgba(100, 114, 125, 0.5);
        }
        tooltip label {
          color: white;
        }

        #workspaces button {
            padding: 0 5px;
            /* background: transparent; */
            color: white;
            border-bottom: 3px solid transparent;
        }

        #workspaces button.focused {
            background: #64727D;
            border-bottom: 3px solid white;
        }

        /* #mode, #clock, #battery #keyboard-state { */
            /* padding: 2px 6px; */
            /* border-radius: 25%; */
        /* } */

        /* #clock, */
        /* #battery, */
        /* #cpu, */
        /* #memory, */
        /* #temperature, */
        /* #network, */
        /* #pulseaudio, */
        /* #custom-media, */
        /* #tray, */
        /* #mode, */
        /* #custom-power, */
        /* #custom-menu, */
        /* #idle_inhibitor { */
            /* padding: 0 10px; */
        /* } */


        #idle_inhibitor,
        #cava,
        #scratchpad,
        #mode,
        #window,
        #clock,
        #battery,
        #backlight,
        #wireplumber,
        #tray,
        #privacy,
        #temperature,
        #mpris,
        #bluetooth,
        #power-profiles-daemon,
        #pulseaudio,
        #pulseaudio-slider,
        #backlight-slider,
        #memory,
        #disk,
        #cpu,
        /* #custom-gpu-usage, */
        #custom-weather,
        #network,
        #taskbar,
        #load,
        #custom-notification,
        #systemd-failed-units
        {
            /* padding: 10px 4px 10px 4px; */
            padding: 6px 8px;
            margin: 8px 0px;
            border-radius: 4px;
            /* background-color: #282828; */
            /* background-color: alpha(@mantle, 0.85); */
            background-color: alpha(@surface0, 0.85);
            /* background-color: @mantle; */
        /* #191C19 */
            /* color: white; */
            /* color: red; */
        }

        #clock {
            padding: 6px 14px;
        }


        #battery.charging, #battery.plugged {
            background-color: #98971a;
            color: #282828;
        }

        #mpris.playing {
            background-color: @green;
        }

        #mpris.paused {
            background-color: rgba(80, 80, 80, 0.5);
        }

        #mpris.stopped {
            background-color: @red;
        }

        #mpris.spotify {
            background-color: #20D465;
            color: black;
        }

        /* #mpris.youtube { */
        #mpris.firefox {
            /* background-color: #FB0B08; */
            background-color: @peach;
            color: black;
        }

        label:focus {
            background-color: #000000;
        }

        #bluetooth.on {
          color: ${bluetooth-blue};
          /* color: @teal; */
        }



        #bluetooth.connected, #pulseaudio.bluetooth {
          background-color: @teal;
          color: @crust;
        }
        #bluetooth.disabled {
          color: @surface2;
        }
        #bluetooth.off {
          color: @surface2;
        }

        /*    bluetooth */
        /*    bluetooth.disabled */
        /*    bluetooth.off */
        /*    bluetooth.on */
        /*    bluetooth.connected */
        /*    bluetooth.discoverable */
        /*    bluetooth.discovering */
        /*    bluetooth.pairable */



        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
        }

        #mode {
            background-color: #689d6a;
            color: #282828;
            /* box-shadow: inset 0 -3px #ffffff; */
        }

        /* #mode { */
            /* background: #64727D; */
            /* border-bottom: 3px solid white; */
        /* } */

        /* #clock { */
            /* background-color: #64727D; */
        /* } */

        /* #battery { */
            /* background-color: #ffffff; */
            /* color: black; */
        /* } */

        /* #battery.charging { */
            /* color: white; */
            /* background-color: #26A65B; */
        /* } */

        /* @keyframes blink { */
            /* to { */
                /* background-color: #ffffff; */
                /* color: black; */
            /* } */
        /* } */

        #battery.warning:not(.charging) {
            background: #f53c3c;
            color: white;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: steps(12);
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        /* #systemd-failed-units { */
          /* color: red; */
        /* } */

        /* #systemd-failed-units.ok { */
          /* color: green; */
        /* } */

        /* #keyboard-state { */

        /* } */

        /* #bluetooth.on { */
            /* color: green; */
        /* } */

        /* #bluetooth.off { */
            /* color: red; */
        /* } */


        /* #bluetooth */
        /* #bluetooth.disabled */
        /* #bluetooth.off */
        /* #bluetooth.on */
        /* #bluetooth.connected */
        /* #bluetooth.discoverable */
        /* #bluetooth.discovering */
        /* #bluetooth.pairable */

        #network.disabled {
            color: @mauve;
        }

        #network.enabled {
            color: @green;
        }

        #network.wifi, #network.ethernet, #network.linked {
          color: @green;
        }

        #network.disabled, #network.disconnected {
          background-color: @red;
          color: @crust;
        }

        /* #network */
        /* #network.disabled */
        /* #network.disconnected */
        /* #network.linked */
        /* #network.ethernet */
        /* #network.wifi */

        #power-profiles-daemon {
        color: @crust;
        }

        #power-profiles-daemon.performance {
        background-color: @red;
        }

        #power-profiles-daemon.balanced {
        background-color: @peach;
        }

        #power-profiles-daemon.power-saver {
        background-color: @green;
        }

        #power-profiles-daemon.default {
        background-color: @sky;
        }



        /* #pulseaudio */
        /* #pulseaudio.bluetooth */
        /* #pulseaudio.muted */
        /* #pulseaudio.source-muted */

        /* #pulseaudio-slider slider { */
            /* min-height: 0px; */
            /* min-width: 0px; */
            /* opacity: 0; */
            /* background-image: none; */
            /* border: none; */
            /* box-shadow: none; */
        /* } */
        /* #pulseaudio-slider trough { */
            /* min-height: 80px; */
            /* min-width: 10px; */
            /* border-radius: 5px; */
            /* background-color: black; */
        /* } */
        /* #pulseaudio-slider highlight { */
            /* min-width: 10px; */
            /* border-radius: 5px; */
            /* background-color: green; */
        /* } */


        /* #network */
        /* #network.disabled */
        /* #network.disconnected */
        /* #network.linked */
        /* #network.ethernet */
        /* #network.wifi */

        #temperature.critical {
            background-color: @red;
            color: @crust;
        }

        #memory.warning { background-color: @flamingo; color: @crust; }
        #memory.critical { background-color: @red; color: @crust; }
        #disk.warning { background-color: @flamingo; color: @crust; }
        #disk.critical { background-color: @red; color: @crust; }
        #cpu.warning { background-color: @flamingo; color: @crust; }
        #cpu.critical { background-color: @red; color: @crust; }

        #systemd-failed-units {
          background-color: @red;
          color: @crust;
        }

        #custom-notification {
          font-family: "NotoSansMono Nerd Font";
        }

        #pulseaudio-slider slider {
            min-height: 0px;
            min-width: 0px;
            opacity: 0;
            background-image: none;
            border: none;
            box-shadow: none;
        }
        #pulseaudio-slider trough {
            min-height: 10px;
            min-width: 120px;
            border-radius: 5px;
            background-color: @mantle;
        }
        #pulseaudio-slider highlight {
            min-width: 10px;
            border-radius: 5px;
            background-color: @pink;
            /* background-color: @flamingo; */
        }

        #backlight-slider slider {
            min-height: 0px;
            min-width: 0px;
            opacity: 0;
            background-image: none;
            border: none;
            box-shadow: none;
        }
        #backlight-slider trough {
            min-height: 10px;
            min-width: 120px;
            border-radius: 5px;
            background-color: black;
        }
        #backlight-slider highlight {
            min-width: 10px;
            border-radius: 5px;
            background-color: @yellow;
        }


        #tray > widget:hover {
            color: red;
            background-color: @surface2;
            border-radius: 2pt;
        }

        window#waybar.empty {
            background-color: transparent;
        }

        #tray menu {
            background-color: red;
        }

        #taskbar button {
            padding: 4px 10px;
            margin: 0px 3px;
            background-color: alpha(@surface1, 0.5);
        }

        #taskbar button.active {
            background-color: alpha(@surface2, 1.0);
            border: 1px solid gray;
        }

        #taskbar button.fullscreen {
            background-color: alpha(@yellow, 0.8);
            border: 1px solid @yellow;
        }

        #taskbar button.maximized {
            background-color: alpha(@red, 0.8);
            border: 1px solid @red;
        }

        #taskbar button.minimized {
            background-color: alpha(@sky, 0.8);
            border: 1px solid @sky;
        }

        #taskbar button > widget:hover {
            background: green;
        }

        #cava {
            /* padding: 10px 100px; */
            color: @sky;
        }
      '';
  };

  # TODO: create and submit a home-manager module for this
  # TODO: install some .thThemes and .sublime-syntax

  home.packages = builtins.attrValues scripts;
}
