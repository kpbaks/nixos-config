{
  config,
  osConfig,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  # And configure

  # [[start]]
  # type = "workspaces"
  # all_monitors = false

  # [start.name_map]
  # 1 = "󰙯"
  # 2 = "icon:firefox"
  # 3 = ""
  # Games = "icon:steam"
  # Code = ""

  programs.ironbar = {
    enable = true;
    systemd = true;
    config =
      let
        margin = 0;
      in
      rec {
        name = "primary";
        position = "bottom";
        height = 56; # default 42
        margin.top = margin;
        margin.bottom = margin;
        margin.left = margin;
        margin.right = margin;
        popup_gap = 8;
        start_hidden = false;

        # start = [
        #   {
        #     type = "workspaces";
        #     all_monitors = true;
        #     name_map = {
        #       "1" = 
        #     }
        #   }
        # ]

        # [end]]
        # type = "music"
        # player_type = "mpd"
        # music_dir = "/home/jake/Music"
        start = [
          {
            type = "launcher";
            favorites = [
              "kitty"
              "thunderbird"
            ];
            show_names = false;
          }
        ];
        center = [
          {
            type = "focused";
            show_icon = true;
            show_title = true;
            truncate = "end";
          }
        ];

        end = [
          {
            type = "volume";
            max_volume = 100;
            format = "{icon} {percentage}%";
            icons = {
              volume_high = "󰕾";
              volume_medium = "󰖀";
              volume_low = "󰕿";
              muted = "󰝟";
            };
          }
          {
            type = "music";
            player_type = "mpris";
            music_dir = "${config.home.homeDirectory}/Music";
            truncate = "end";
            format = "{icon} / {artist} {title}";
            icons = {
              play = "";
              pause = "";
            };
            on_mouse_enter = ''${pkgs.ironbar}/bin/ironbar bar ${name} show-popup music'';
            on_mouse_exit = ''${pkgs.ironbar}/bin/ironbar bar ${name} hide-popup music'';
            transition_type = "crossfade";
          }
          {
            type = "network_manager";
            icon_size = 32;
          }
          (
            # FIXME(Sun Sep 22 02:48:14 PM CEST 2024): does not work
            # if osConfig.services.upower.enable then
            if true then
              {
                type = "upower";
                format = "{state} {percentage}% ≈ {time_remaining}";
              }
            else
              { }
          )
          {
            type = "tray";
          }
          {
            type = "clock";
            format = "%d/%m/%Y %H:%M:%S";
          }

          {
            # FIXME: not showing up
            # https://github.com/JakeStanger/ironbar/discussions/724
            type = "script";
            cmd = "niri msg --json keyboard-layouts | ${pkgs.jaq}/bin/jaq -r '.names[.current_idx]'";
            mode = "poll";
            interval = 5000; # ms
            # on-click = "";
            tooltip = "";
          }
          # {
          #   type = "sys_info";
          #   interval = {
          #     cpu = 1;
          #     disks = 300;
          #     memory = 30;
          #     networks = 3;
          #     temps = 5;
          #   };

          #   format = [
          #     " {cpu_percent}% | {temp_c:coretemp-Package-id-0}°C"
          #     " {memory_used} / {memory_total} GB ({memory_percent}%)"
          #     "| {swap_used} / {swap_total} GB ({swap_percent}%)"
          #     "󰋊 {disk_used:/} / {disk_total:/} GB ({disk_percent:/}%)"
          #     # "󰓢 {net_down:enp39s0} / {net_up:enp39s0} Mbps"
          #     "󰖡 {load_average:1} | {load_average:5} | {load_average:15}"
          #     "󰥔 {uptime}"
          #   ];
          # }
          (
            if config.services.swaync.enable then
              {
                type = "notifications";
                show_count = true;
                icons = {
                  closed_none = "󰍥";
                  closed_some = "󱥂";
                  closed_dnd = "󱅯";
                  open_none = "󰍡";
                  open_some = "󱥁";
                  open_dnd = "󱅮";
                };
              }
            else
              { }
          )
        ];
      };

    style =
      let
        catppuccin-colors = pkgs.lib.pipe config.flavor [
          (builtins.mapAttrs (k: v: "@define-color ${k} ${v.hex}"))
          builtins.attrValues
          lib.concatLines
        ];
      in
      catppuccin-colors + (builtins.readFile ./style.css);
    # `Cargo.toml` features to enable
    features = [
      # "workspaces+niri"
    ];
  };
}
