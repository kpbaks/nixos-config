{
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = true;
        use_pager = false;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 24 * 7;
      };
      # TODO: make pr to tealdeer to support a dim flag, similar to `set_color --dim` in fish
      style = {
        command_name = {
          bold = true;
          foreground = "blue";
          italic = false;
          underline = false;
        };
        description = {
          bold = true;
          italic = true;
          underline = false;
          foreground = "white";
        };
        example_code = {
          bold = false;
          foreground = "cyan";
          italic = false;
          underline = false;
        };
        example_text = {
          bold = false;
          foreground = "green";
          italic = false;
          underline = false;
        };
        example_variable = {
          bold = false;
          foreground = "magenta";
          italic = true;
          underline = false;
        };
      };
    };
  };
}
