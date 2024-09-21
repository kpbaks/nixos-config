{ config, pkgs, ... }:
{
  programs.fuzzel = {
    enable = false;
    # catppuccin.enable = false;

    settings = {
      main = {
        layer = "overlay";
        terminal = "${pkgs.kitty}/bin/kitty";
        font = "JetBrainsMono Nerd Font";
        dpi-aware = "yes";
        icons-enabled = true;
        fuzzy = true;
        show-actions = true;
        anchor = "center";
        lines = 12;
        width = 40; # in characters
        horizontal-pad = 60; # px
        vertical-pad = 20; # px
        inner-pad = 20; # px
      };
      border.width = 2; # px
      border.radius = 10; # px

      colors =
        let
          hex2fuzzel-color = hex: "${builtins.substring 1 6 hex}ff";
          catppuccin2fuzzel-color = name: hex2fuzzel-color config.flavor.${name}.hex;
        in
        builtins.mapAttrs (_: color: catppuccin2fuzzel-color color) {
          background = "surface0";
          text = "text";
          match = "mauve";
          selection = "overlay0";
          selection-text = "text";
          selection-match = "pink";
          border = "blue";
        };
    };
  };
}
