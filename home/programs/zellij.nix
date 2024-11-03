{
  self,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  plugins =
    let
      inherit (pkgs) fetchurl;
    in
    {
      zj-quit = pkgs.fetchurl {
        url = "https://github.com/cristiand391/zj-quit/releases/download/0.3.0/zj-quit.wasm";
        hash = "sha256-f1D3cDuLRZ5IqY3IGq6UYSEu1VK54TwmkmwWaxVQD2A=";
      };
      room = fetchurl {
        url = "https://github.com/rvcas/room/releases/download/v1.1.1/room.wasm";
        hash = lib.fakeHash;
      };
    };
in

{

  programs.zellij.enable = true;
  home.sessionVariables = {
    ZELLIJ_AUTO_ATTACH = "true";
    ZELLIJ_AUTO_EXIT = "false";
  };
  # TODO: how to start zellij with `zellij --layout welcome`
  # TODO: prevent integration if terminal is embedded in another program,
  # ala. in kate or dolphin or vscode
  # `set -q KATE_PID`
  # `set -q VSCODE_INTEGRATION`
  programs.zellij.enableFishIntegration = false;
  programs.zellij.enableBashIntegration = false;
  programs.zellij.enableZshIntegration = false;

  programs.zellij.settings = {
    default_mode = "pane";
    copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
    copy_clipboard = "primary";
    copy_on_selection = true;
    # layout_dir = "${zellij_dir}/layouts";
    # theme_dir = "${zellij_dir}/themes";

    ui.pane_frames.hide_session_name = true;
    plugins = {
      zj-quit = {
        location = "file://${plugins.zj-quit}";
        confirm_key = "q";
        cancel_key = "Esc";
      };
    };

    # keybinds = {
    #   shared_except = {
    #     _args = [ "locked" ];
    #     bind = {
    #       _args = [ "f" ];
    #       # _props = {
    #       ToggleFocusFullscreen = true;
    #       SwitchToMode = "Normal";
    #       # };

    #     };
    #     # bind.f = [ "ToggleFocusFullcreen"  ];

    #     # bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }

    #   };

  };

  #       keybinds clear-defaults=true {
  #   shared_except "locked" {
  #     bind "Ctrl q" {
  #       LaunchOrFocusPlugin "zj-quit" {
  #         floating true
  #       }
  #     }
  # }

  # plugins {
  #   zj-quit location="file:/path/to/zj-quit.wasm"
  # }
  # };

  # programs.zellij.extraConfig = # kdl
  #   ''

  #   '';

  xdg.configFile."zellij/layouts/default.kdl".text =
    # kdl
    ''
      pane_frames true
      simplified_ui false

      layout {
        default_tab_template {
          pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
          }

          children
          
          pane size=1 borderless=true {
            plugin location="zellij:status-bar"
          }
        }
      }
    '';

  # TODO: dependent on my pr `feature/query-pane-names`
  # programs.fish.interactiveShellInit =
  #   let
  #     zellij = "${self.programs.zellij.package}/bin/zellij";
  #     toggle-pane-frames = # fish
  #       ''
  #         set -l panes (${zellij} action query-pane-names)
  #         if test (count $panes) -gt 1
  #           ${zellij} action toggle-pane-frames
  #         end
  #       '';
  #   in
  #   # fish
  #   ''
  #     if set -q ZELLIJ
  #       ${toggle-pane-frames}

  #       function _zellij_toggle_pane_frames_on_exit --on-event fish_exit
  #         ${toggle-pane-frames}
  #       end
  #     end
  #   '';

  # xdg.configFile."zellij/layouts/default.kdl".text =
  #   # kdl
  #   ''
  #     pane_frames true
  #     simplified_ui false

  #     layout {
  #       default_tab_template {
  #         pane size=1 borderless=false {
  #           plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
  #             format_left   "{mode} #[fg=#89B4FA,bold]{tabs}"
  #             format_center "{session}"
  #             format_right  "{command_git_branch} {datetime}"
  #             format_space  ""

  #             border_enabled  "false"
  #             border_char     "─"
  #             border_format   "#[fg=#6C7086]{char}"
  #             border_position "top"

  #             hide_frame_for_single_pane "true"

  #             mode_normal  "#[bg=blue] "
  #             mode_tmux    "#[bg=#ffc387] "

  #             tab_normal   "#[fg=#6C7086] {name} "
  #             tab_active   "#[fg=#9399B2,bold,italic] {name} "

  #             command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
  #             command_git_branch_format      "#[fg=blue] {stdout} "
  #             command_git_branch_interval    "10"
  #             command_git_branch_rendermode  "static"

  #              // formatting for inactive tabs
  #             tab_normal              "#[fg=#6C7086]{name}"
  #             tab_normal_fullscreen   "#[fg=#6C7086]{name}"
  #             tab_normal_sync         "#[fg=#6C7086]{name}"

  #             // formatting for the current active tab
  #             tab_active              "#[fg=blue,bold]{name}#[fg=yellow,bold]{floating_indicator}"
  #             tab_active_fullscreen   "#[fg=yellow,bold]{name}#[fg=yellow,bold]{fullscreen_indicator}"
  #             tab_active_sync         "#[fg=green,bold]{name}#[fg=yellow,bold]{sync_indicator}"

  #             // separator between the tabs
  #             tab_separator           "#[fg=cyan,bold] ⋮ "

  #             // indicators
  #             tab_sync_indicator       " "
  #             tab_fullscreen_indicator " "
  #             tab_floating_indicator   ""

  #             datetime        "#[fg=#6C7086,bold] {format} "
  #             datetime_format "%A, %d %b %Y %H:%M:%s"
  #             datetime_timezone "Europe/Copenhagen"
  #           }
  #         }

  #         children
  #       }
  #     }
  #   '';
}
