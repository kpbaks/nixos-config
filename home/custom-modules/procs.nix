{
  config,
  pkgs,
  ...
}:
{

  # https://github.com/dalance/procs
  # FIXME: make default look like github readme
  xdg.configFile."procs/config.toml".source = (pkgs.formats.toml { }).generate "procs-config" {
    columns = [
      {
        align = "Left";
        kind = "Pid";
        nonnumeric_search = false;
        numeric_search = true;
        style = "BrightYellow|Yellow";
      }
      {
        align = "Left";
        kind = "User";
        nonnumeric_search = true;
        numeric_search = false;
        style = "BrightGreen|Green";
      }
      {
        align = "Left";
        kind = "Separator";
        nonnumeric_search = false;
        numeric_search = false;
        style = "White|BrightBlack";
      }
      {
        align = "Left";
        kind = "Tty";
        nonnumeric_search = false;
        numeric_search = false;
        style = "BrightWhite|Black";
      }
      {
        align = "Right";
        kind = "UsageCpu";
        nonnumeric_search = false;
        numeric_search = false;
        style = "ByPercentage";
      }
      {
        align = "Right";
        kind = "UsageMem";
        nonnumeric_search = false;
        numeric_search = false;
        style = "ByPercentage";
      }
      {
        align = "Left";
        kind = "CpuTime";
        nonnumeric_search = false;
        numeric_search = false;
        style = "BrightCyan|Cyan";
      }
      {
        align = "Right";
        kind = "MultiSlot";
        nonnumeric_search = false;
        numeric_search = false;
        style = "ByUnit";
      }
      {
        align = "Left";
        kind = "Separator";
        nonnumeric_search = false;
        numeric_search = false;
        style = "White|BrightBlack";
      }
      {
        align = "Left";
        kind = "Command";
        nonnumeric_search = true;
        numeric_search = false;
        style = "BrightWhite|Black";
      }
    ];
    display = {
      abbr_sid = true;
      ascending = "▲";
      color_mode = "Auto";
      cut_to_pager = false;
      cut_to_pipe = false;
      cut_to_terminal = true;
      descending = "▼";
      separator = "│";
      show_children_in_tree = true;
      show_footer = true;
      show_header = true;
      show_kthreads = true;
      show_parent_in_tree = true;
      show_self = false;
      show_self_parents = false;
      show_thread = true;
      show_thread_in_tree = true;
      theme = "Auto";
      tree_symbols = [
        "│"
        "─"
        "┬"
        "├"
        "└"
      ];
    };
    docker = {
      path = "unix:///var/run/docker.sock";
    };
    pager = {
      detect_width = false;
      mode = "Auto";
      use_builtin = false;
      command = config.home.sessionVariables.PAGER;
    };
    search = {
      case = "Smart";
      logic = "And";
      nonnumeric_search = "Partial";
      numeric_search = "Exact";
    };
    sort = {
      column = 5; # cpu
      order = "Descending";
      # order = "Ascending";
    };
    style = {
      by_percentage = {
        color_000 = "BrightBlue|Blue";
        color_025 = "BrightGreen|Green";
        color_050 = "BrightYellow|Yellow";
        color_075 = "BrightRed|Red";
        color_100 = "BrightRed|Red";
      };
      by_state = {
        color_d = "BrightRed|Red";
        color_k = "BrightYellow|Yellow";
        color_p = "BrightYellow|Yellow";
        color_r = "BrightGreen|Green";
        color_s = "BrightBlue|Blue";
        color_t = "BrightCyan|Cyan";
        color_w = "BrightYellow|Yellow";
        color_x = "BrightMagenta|Magenta";
        color_z = "BrightMagenta|Magenta";
      };
      by_unit = {
        color_g = "BrightYellow|Yellow";
        color_k = "BrightBlue|Blue";
        color_m = "BrightGreen|Green";
        color_p = "BrightRed|Red";
        color_t = "BrightRed|Red";
        color_x = "BrightBlue|Blue";
      };
      header = "BrightWhite|Black";
      tree = "BrightWhite|Black";
      unit = "BrightWhite|Black";
    };

    # columns = [
    #   {
    #     kind = "Pid";
    #     style = "BrightYellow|Yellow";
    #     numeric_search = true;
    #     nonnumeric_search = false;
    #   }
    #   {
    #     kind = "Username";
    #     style = "BrightGreen|Green";
    #     numeric_search = false;
    #     nonnumeric_search = true;
    #     align = "Right";
    #   }
    # ];
    # display = {
    #   show_self = false;
    #   show_thread = true;
    #   color_mode = "Auto";
    #   show_header = true;
    #   show_footer = true;
    # };
  };
}
