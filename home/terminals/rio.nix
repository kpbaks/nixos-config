{ pkgs, ... }:
{
  programs.rio = {
    enable = true;
    # catppuccin.enable = false;
    settings = {
      shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [ "--login" ];
      };
      editor = {
        program = "hx";
        args = [ ];
      };
      # confirm-before-quit = true;
      # cursor = {
      #   shape = "beam";
      #   blinking = false;
      # };
      # env-vars = [];
      # hide-mouse-cursor-when-typing = false;
      # window = {
      #   blur = true;
      # };
      # blinking-cursor = false;
      # hide-cursor-when-typing = false;
      # confirm-before-quit = true;
      # use-fork = true; # faster on linux
      # window.decorations = "Disabled";
      # fonts.family = "Iosevka Nerd Font Mono";
      # fonts.size = 16;

      # keyboard.use-kitty-keyboard-protocol = false;
      # scroll.multiplier = 5.0;
      # scroll.divider = 1.0;

      # adaptive-theme.light = "belafonte-day";
      # adaptive-theme.dark = "belafonte-night";
    };
  };
}
