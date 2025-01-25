{
  config,
  lib,
  pkgs,
  ...
}:
{

  # Use `niri msg outputs` to both the name dimensions of connected outputs
  programs.niri.settings.outputs = {
    # Laptop screen
    "eDP-1" = {
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
      position.x = 0;
      position.y = -1600;
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
