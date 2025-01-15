{

  programs.bacon = {
    enable = true;
    settings = {
      summary = true;
      wrap = false;
      reverse = true;
      export = {
        enabled = true;
        path = ".bacon-locations";
        line_format = "{kind} {path}:{line}:{column} {message}";
      };
      keybindings = {
        esc = "back";
        s = "toggle-summary";
        w = "toggle-wrap";
        t = "toggle-backtrace";
        q = "quit";
        g = "scroll-to-top";
        shift-g = "scroll-to-bottom";
        c = "job:clippy";
      };
    };
  };
}
