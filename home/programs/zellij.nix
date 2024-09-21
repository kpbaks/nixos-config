{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.zellij.enable = true;

  xdg.configFile."zellij/layouts/default.kdl".text =
    # kdl
    ''
      pane_frames false
      simplified_ui false

      layout {
        default_tab_template {
          pane size=1 borderless=false {
            plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
              format_left   "{mode} #[fg=#89B4FA,bold]{tabs}"
              format_center "{session}"
              format_right  "{command_git_branch} {datetime}"
              format_space  ""

              border_enabled  "false"
              border_char     "─"
              border_format   "#[fg=#6C7086]{char}"
              border_position "top"

              hide_frame_for_single_pane "true"

              mode_normal  "#[bg=blue] "
              mode_tmux    "#[bg=#ffc387] "

              tab_normal   "#[fg=#6C7086] {name} "
              tab_active   "#[fg=#9399B2,bold,italic] {name} "

              command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
              command_git_branch_format      "#[fg=blue] {stdout} "
              command_git_branch_interval    "10"
              command_git_branch_rendermode  "static"

               // formatting for inactive tabs
              tab_normal              "#[fg=#6C7086]{name}"
              tab_normal_fullscreen   "#[fg=#6C7086]{name}"
              tab_normal_sync         "#[fg=#6C7086]{name}"

              // formatting for the current active tab
              tab_active              "#[fg=blue,bold]{name}#[fg=yellow,bold]{floating_indicator}"
              tab_active_fullscreen   "#[fg=yellow,bold]{name}#[fg=yellow,bold]{fullscreen_indicator}"
              tab_active_sync         "#[fg=green,bold]{name}#[fg=yellow,bold]{sync_indicator}"

              // separator between the tabs
              tab_separator           "#[fg=cyan,bold] ⋮ "

              // indicators
              tab_sync_indicator       " "
              tab_fullscreen_indicator " "
              tab_floating_indicator   ""

              datetime        "#[fg=#6C7086,bold] {format} "
              datetime_format "%A, %d %b %Y %H:%M:%s"
              datetime_timezone "Europe/Copenhagen"
            }
          }

          children
        }
      }
    '';
}
