{

  programs.fish.shellInit =
    # catppuccin-colors
    # +
    # fish
    ''
      # set -g fish_color_normal
      # set -g fish_color_command
      # set -g fish_color_keyword
      # set -g fish_color_quote
      # set -g fish_color_redirection
      # set -g fish_color_end
      # set -g fish_color_error
      # set -g fish_color_param
      # set -g fish_color_valid_path
      # set -g fish_color_option
      # set -g fish_color_comment
      # set -g fish_color_selection
      # set -g fish_color_operator
      # set -g fish_color_escape
      # set -g fish_color_autosuggestion
      # set -g fish_color_cwd
      # set -g fish_color_cwd_root
      # set -g fish_color_user
      # set -g fish_color_host
      # set -g fish_color_host_remote
      # set -g fish_color_status
      # set -g fish_color_cancel
      # set -g fish_color_search_match
      # set -g fish_color_history_current

      set -g fish_color_keyword magenta
      set -g fish_color_option brcyan
      # set -g fish_pager_color_progress
      set -g fish_pager_color_background
      # set -g fish_pager_color_prefix
      # set -g fish_pager_color_completion
      # set -g fish_pager_color_description
      set -g fish_pager_color_selected_background
      set -g fish_pager_color_selected_prefix
      set -g fish_pager_color_selected_completion
      set -g fish_pager_color_selected_description
      set -g fish_pager_color_secondary_background
      set -g fish_pager_color_secondary_prefix
      set -g fish_pager_color_secondary_completion
      set -g fish_pager_color_secondary_description
    '';
}
