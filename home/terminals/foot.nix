{ ... }:
{
  programs.foot = {
    enable = false;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrains Nerd Font Mono:size=14";
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
