{ pkgs, ... }:
{

  xdg.configFile."uplot/uplot.yml".source =
    let
      ratio = 1920 / 1080;
      width = 80;
      height = builtins.floor (width / ratio);
    in
    (pkgs.formats.yaml { }).generate "uplot-config"

      {
        inherit width height;
        # width = 80; # cells
        # height = 40; # cells
      };

  # https://github.com/piotrmurach/tty-pie
  # https://github.com/Martin-Nyaga/termplot
}
