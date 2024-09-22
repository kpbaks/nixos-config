{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ gum ];

  home.sessionVariables =

    # TODO: do for rest of gum subcommands
    builtins.mapAttrs (_: color: config.flavor.${color}.hex) {
      GUM_CONFIRM_PROMPT_FOREGROUND = "sky";
      GUM_CONFIRM_SELECTED_FOREGROUND = "teal";
      GUM_CONFIRM_UNSELECTED_FOREGROUND = "crust";

      GUM_CHOOSE_CURSOR_FOREGROUND = "sky";
      GUM_CHOOSE_HEADER_FOREGROUND = "sky";
      GUM_CHOOSE_ITEM_FOREGROUND = "sky";
      GUM_CHOOSE_SELECTED_FOREGROUND = "sky";
    };
}
