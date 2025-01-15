{ inputs, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    # package = inputs.ghostty.packages.${pkgs.stdenv.system}.default;
    settings = {

      auto-update = "check";
      auto-update-channel = "tip";
      bold-is-bright = true;
      linux-cgroup = "always";

      # window-theme = dark
      window-theme = "ghostty";
      window-padding-color = "extend";
      # window-theme = system
      gtk-wide-tabs = true;
      gtk-tabs-location = "top";
      adw-toolbar-style = "raised";
      gtk-adwaita = true;
      # adw-toolbar-style = "raised-border";
      gtk-titlebar = true;

      background-opacity = 1.0;

      cursor-style = "bar";

      mouse-shift-capture = true;
      font-size = 16;

      font-family = "Iosevka Nerd Font Mono";

      mouse-scroll-multiplier = 2;

      fullscreen = false;

      # keybind = l

      # theme = Hardcore
      # theme = tokyonight
      # theme = GruvboxDarkHard
      # theme = GruvboxDark
      # theme = GruvboxLight

      theme = "dark:Kanagawa Wave,light:GruvboxLight";

      # theme = dark:catppuccin-frappe,light:catppuccin-latte

      # keybind = global:ctrl+s=toggle_quick_terminal

      focus-follows-mouse = true;

      keybind = [
        "global:ctrl+enter=toggle_tab_overview"
        "global:f11=toggle_fullscreen"
      ];

    };
  };
}
