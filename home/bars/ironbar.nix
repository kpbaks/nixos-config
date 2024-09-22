{
  config,
  inputs,
  pkgs,
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
    config = {
      position = "bottom";
      height = 56; # default 42
      margin.top = 8;
      margin.bottom = 8;
      margin.left = 8;
      margin.right = 8;
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
          show_names = true;
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
        }
        {
          type = "music";
          player_type = "mpris";
          music_dir = "${config.home.homeDirectory}/Music";
        }
        {
          type = "network_manager";
          icon_size = 32;
        }
        {
          type = "upower";
        }
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
          cmd = "niri msg --json keyboard-layouts | ${pkgs.jaq} -r '.names[.current_idx]'";
          mode = "poll";
          interval = 5000; # ms
          # on-click = "";
          tooltip = "";
        }
        {
          type = "notifications";
        }
      ];
    };
    style =
      # css
      ''
        .workspaces .item:hover {
            box-shadow: inset 0 -3px;
        }
      '';
    # package = inputs.ironbar;
    features = [
      # "feature"
      # "another_feature"
    ];
  };
}
