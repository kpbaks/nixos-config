{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # ghostty-shaders = pkgs.fetchFromGitHub {
  #   owner = "hackr-sh";
  #   repo = "ghostty-shaders";
  #   rev = "3f458157b0d7b9e70eeb19bd27102dc9f8dae80c";
  #   hash = "sha256-N6MP9QX/80ppg+TdmxmMVYsoeguicRIXfPHyoMGt92s=";
  # };
  boo = pkgs.writeScriptBin "boo" "${config.programs.ghostty.package}/bin/ghostty +boo";
in

# https://ghostty.org/docs/help/terminfo#copy-ghostty's-terminfo-to-a-remote-machine
{

  # xdg.configFile."ghostty/themes/Eldritch".source = "${inputs.eldritch-theme-ghostty}/Eldritch";

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs.ghostty;
    settings = {

      auto-update = "check";
      auto-update-channel = "tip";
      bold-is-bright = false;
      linux-cgroup = "always";

      # window-theme = dark
      window-theme = "ghostty";
      window-padding-color = "extend";
      # window-theme = system
      gtk-wide-tabs = true;
      gtk-tabs-location = "top";
      adw-toolbar-style = "raised";
      # gtk-adwaita = true;
      # adw-toolbar-style = "raised-border";
      gtk-titlebar = true;

      # background-opacity = 0.95;
      background-opacity = 1;
      background-blur = false;

      cursor-style = "bar";

      mouse-shift-capture = true;
      font-size = 16;

      font-family = "Iosevka Nerd Font Mono";
      # font-family = "JetBrainsMono Nerd Font Mono";

      mouse-scroll-multiplier = 2;

      fullscreen = false;
      window-padding-x = 0;
      window-padding-y = 0;
      window-vsync = true;

      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = false;
      clipboard-paste-bracketed-safe = false;
      copy-on-select = true;
      # theme = Hardcore
      # theme = tokyonight
      # theme = GruvboxDarkHard
      # theme = GruvboxDark
      # theme = GruvboxLight

      # theme = "Builtin Pastel Dark";
      # theme = "iceberg-dark";
      # theme = "0x96f";
      # theme = "dark:iceberg-dark,light:iceberg-light";
      # theme = "dark:BlueDolphin,light:Builtin Solarized Light";
      # theme = "Eldritch";
      # theme = "0x96f";
      # theme = "noctalia"; # Updated by `noctalia-shell` using `matugen`
      theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
      # theme = "shadow";
      # theme = "dark:Kanagawa Wave,light:GruvboxLight";

      # theme = dark:catppuccin-frappe,light:catppuccin-latte

      # keybind = global:ctrl+s=toggle_quick_terminal

      # custom-shader = "${ghostty-shaders}/water.glsl";
      # TODO: use if merged https://github.com/hackr-sh/ghostty-shaders/pull/47
      # custom-shader = "${inputs.ghostty-shaders}/cursor_blaze.glsl";
      # custom-shader = "${inputs.ghostty-shaders}/spotlight.glsl";
      focus-follows-mouse = true;

      # https://ghostty.org/docs/config/keybind
      keybind = [
        "ctrl+enter=toggle_tab_overview"
        "f11=toggle_fullscreen"
        "ctrl+shift+w=close_surface"
      ]
      ++ lib.optionals config.programs.zellij.enable [
        "ctrl+shift+t=unbind" # spawn tab
        "ctrl+shift+w=unbind" # close tab
        "ctrl+shift+n=unbind" # open new window
        "ctrl+page_up=unbind"
        "ctrl+page_down=unbind"
        "ctrl+tab=unbind"
        "ctrl+shift+tab=unbind"
        "ctrl+shift+o=unbind" # open vertical split
        "ctrl+shift+e=unbind" # open horizontal split
        "ctrl+comma=unbind" # open ghostty config
        "ctrl+shift+comma=unbind" # reload ghostty config
        "ctrl+alt+left=unbind"
        "ctrl+shift+a=unbind" # select all text
        "ctrl+shift+left=unbind"
        "ctrl+shift+right=unbind"
        "ctrl+shift+j=unbind" # write screen contents to tmp file
        "alt+1=unbind"
      ];
    };

    themes = {
      # https://github.com/rjshkhr/dotfiles/blob/main/.config/ghostty/themes/shadow.conf
      shadow = {
        background = "#1D2326";
        foreground = "#E6E7E6";
        # cursor-color = "";
        # selection-background = "";
        # selection-foreground = "";
        palette = [
          "0=#242B2D"
          "1=#BC8F7D"
          "2=#96B088"
          "3=#CCAC7D"
          "4=#7E9AAB"
          "5=#A68CAA"
          "6=#839C98"
          "7=#CED3DC"
          "8=#485457"
          "9=#D4A394"
          "10=#ABC49E"
          "11=#E2BF8F"
          "12=#94B1C4"
          "13=#BC9EC0"
          "14=#97B3AF"
          "15=#E8EBF0"
        ];
      };
    };
  };

  home.packages = [
    boo
  ];
}
