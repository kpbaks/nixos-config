# https://github.com/YaLTeR/niri/wiki/Overview
{
  programs.niri = {
    settings = {
      overview = {
        # zoom = 1.0 / 2.0;
        zoom = 1.0 / 3.0;
        backdrop-color = null;
        # TODO: add support for this in `flake:niri-flake`
        # workspace-shadow.enable = true;
      };
      gestures.hot-corners.enable = false;

      layout.background-color = "transparent";

      # Use `niri msg layers` to see all layers and their properties like namespace.
      layer-rules = [
        {
          # "wallpaper" is the namespace used by `swaybg`
          # "swww-daemon" is the namespace used by ... `swww-daemon`
          matches = [ { namespace = "^wallpaper|swww-daemon$"; } ];
          # TODO: add support for this in `flake:niri-flake`
          place-within-backdrop = true;
          opacity = 0.5;
        }
      ];
    };
  };
}
