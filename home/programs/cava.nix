{ ... }:
{
  programs.cava = {
    enable = true;
    # catppuccin.enable = false;
    catppuccin.transparent = true;
    settings = {
      general.framerate = 60;
      general.sleep_timer = 3;
      # input.method = "alsa";
      output.method = "noncurses";
      # output.method = "sdl_glsl";
      output.alacritty_sync = 0;
      output.orientation = "bottom";
      smoothing.noise_reduction = 88;
      # color = {
      #   # background = "'#000000'";
      #   # foreground = "'#FFFFFF'";
      #   foreground = "'magenta'";

      #   gradient = 1; # on/off
      #   gradient_count = 8;
      #   gradient_color_1 = "'#59cc33'";
      #   gradient_color_2 = "'#80cc33'";
      #   gradient_color_3 = "'#a6cc33'";
      #   gradient_color_4 = "'#cccc33'";
      #   gradient_color_5 = "'#cca633'";
      #   gradient_color_6 = "'#cc8033'";
      # };
    };
  };
}
