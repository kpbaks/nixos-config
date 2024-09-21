{ ... }:
{
  programs.foot = {
    enable = false;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "${font.monospace}:size=14";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 0.9;
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
