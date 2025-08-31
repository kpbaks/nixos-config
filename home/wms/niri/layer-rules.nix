# https://github.com/yaLTeR/niri/wiki/Configuration:-Layer-Rules
{
  config,
  ...
}:
{
  # Use `niri msg layers` to see all layers and their properties like namespace.
  programs.niri.settings.layer-rules = [
    # Block out mako notifications from screencasts.
    {
      matches = [ { namespace = "^notification$"; } ];
      block-out-from = "screencast";
    }
    {
      matches = [ { namespace = "^launcher$"; } ];
      baba-is-float = false;
      opacity = 1.0;
      shadow.enable = true;
      # geometry-corner-radius = config.programs.fuzzel.settings.border.radius;
      # TODO: update niri-flake to accept a float value OR a submodule
      # TODO: support int | float
      geometry-corner-radius =
        let
          r = config.programs.fuzzel.settings.border.radius + 0.0; # Ugly way to convert to float
        in
        {
          bottom-right = r;
          bottom-left = r;
          top-right = r;
          top-left = r;
        };
    }
  ];
}
