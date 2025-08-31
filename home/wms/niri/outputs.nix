{
  config,
  lib,
  pkgs,
  ...
}:
{

  # Use `niri msg outputs` to both the name dimensions of connected outputs
  programs.niri.settings.outputs =
    let
      eDP-1 = {
        x = 2560;
        y = 1600;
      };
    in
    {
      # Laptop screen
      "eDP-1" = {
        # mode = "2560x1600@60.002";
        mode = {
          width = 2560;
          height = 1600;
          refresh = 60.002;
        };
        # TODO: open issue or submit pr to `niri` to add `niri msg output <output> background-color <color>` to the cli
        # background-color = config.flavor.surface2.hex;
        scale = 1.0;
        # 2560x1600
        position.x = 0;
        position.y = 0;
      };
      "Acer Technologies K272HUL T6AEE0058502" = {
        # background-color = config.flavor.surface1.hex;
        scale = 1.0;
        transform.rotation = 0;
        variable-refresh-rate = "on-demand";
        position.x = eDP-1.x;
        position.y = -((eDP-1.y - 1440) / 2);
        background-color = "#003300";
        backdrop-color = "#001100";
      };
      "Sony SONY TV 0x01010101" = {
        # background-color = config.flavor.sky.hex;
        scale = 1.0;
        transform.rotation = 0;
        # Logical size: 1920x1080
        position = {
          x = 0;
          y = -1600;
        };
      };
    };
}
