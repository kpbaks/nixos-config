{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
    # catppuccin.enable = false;

    settings = {
      main = {
        layer = "overlay";
        # terminal = "${pkgs.kitty}/bin/kitty";
        terminal = "${lib.getExe config.default-application.terminal}";
        font = "JetBrainsMono Nerd Font Mono";
        dpi-aware = "auto";
        use-bold = true;
        icons-enabled = true;
        # fuzzy = true;
        match-counter = true;
        match-mode = "fzf";
        show-actions = true;
        placeholder = "Search ";
        hide-before-typing = "no";
        anchor = "center";
        lines = 8;
        width = 64; # in characters
        horizontal-pad = 40; # px
        vertical-pad = 40; # px
        inner-pad = 20; # px
        fields = "filename,name,generic,keywords";
        filter-desktop = true;
      };
      border.width = 2; # px
      border.radius = 10; # px
      # All colors are in RGBA format
      colors = rec {
        background = "212337ff";
        border = "323449ff";
        text = "ebfafaff";
        prompt = "37f499ff";
        placeholder = "7081d0ff";
        input = "37f499ff";
        match = "37f499ff";
        selection = "323449ff";
        selection-text = text;
        selection-match = match;
        counter = "f265b5ff";
      };
      # colors.background-color = lib.mkForce "000000ff";
      # colors =
      #   let
      #     hex2fuzzel-color = hex: "${builtins.substring 1 6 hex}ff";
      #     catppuccin2fuzzel-color = name: hex2fuzzel-color config.flavor.${name}.hex;
      #   in
      #   builtins.mapAttrs (_: color: catppuccin2fuzzel-color color) {
      #     background = "surface0";
      #     text = "text";
      #     match = "mauve";
      #     selection = "overlay0";
      #     selection-text = "text";
      #     selection-match = "pink";
      #     border = "blue";
      #   };
    };
  };
}
