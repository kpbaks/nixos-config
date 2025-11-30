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
    systemd.enable = true;
    package = pkgs.ghostty;
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
      selection-clear-on-copy = true;
      cursor-style-blink = true;
      cursor-click-to-move = true;
      split-divider-color = "#a6e3a1";
      link-previews = true;
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
      # theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
      # theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      theme = "dark:GruvboxDark,light:GruvboxLight";
      # theme = "shadow";
      # theme = "dark:Kanagawa Wave,light:GruvboxLight";

      # theme = dark:catppuccin-frappe,light:catppuccin-latte

      # keybind = global:ctrl+s=toggle_quick_terminal

      # custom-shader = "${ghostty-shaders}/water.glsl";
      # TODO: use if merged https://github.com/hackr-sh/ghostty-shaders/pull/47
      # custom-shader = "${inputs.ghostty-shaders}/cursor_blaze.glsl";
      # custom-shader = "${inputs.ghostty-shaders}/spotlight.glsl";
      focus-follows-mouse = false;

      # https://ghostty.org/docs/config/keybind
      keybind =
        let
          resize_split_amount = "100";
        in
        [
          "ctrl+enter=toggle_tab_overview"
          "f11=toggle_fullscreen"
          "ctrl+shift+w=close_surface"
          "ctrl+shift+comma=unbind" # reload ghostty config (we manage it with home-manager so this will give us nothing)
          "alt+n=new_split:auto" # Like in zellij
          "alt+h=goto_split:left"
          "alt+l=goto_split:right"
          "alt+j=goto_split:down"
          "alt+k=goto_split:up"
          "alt+arrow_left=goto_split:left"
          "alt+arrow_right=goto_split:right"
          "alt+arrow_down=goto_split:down"
          "alt+arrow_up=goto_split:up"
          "alt+shift+h=resize_split:left,${resize_split_amount}"
          "alt+shift+l=resize_split:right,${resize_split_amount}"
          "alt+shift+j=resize_split:down,${resize_split_amount}"
          "alt+shift+k=resize_split:up,${resize_split_amount}"
          # "alt+==equalize_splits"
          "alt+m=toggle_split_zoom"
          "ctrl+shift+z=undo"
          "ctrl+shift+y=redo"
          "ctrl+shift+i=inspector:toggle"
          "ctrl+shift+g=show_gtk_inspector"
          "performable:ctrl+c=copy_to_clipboard"
          "ctrl+shift+f=write_scrollback_file:open" # No search action yet, so this is the best alternative

          # keybind = global:cmd+backquote=toggle_quick_terminal
          # Pane mode ala. zellij
          "ctrl+p>f=toggle_split_zoom"
          "ctrl+p>n=new_split:auto"
          "ctrl+p>h=goto_split:left"
          "ctrl+p>l=goto_split:right"
          "ctrl+p>j=goto_split:down"
          "ctrl+p>k=goto_split:up"
          "ctrl+p>arrow_left=goto_split:left"
          "ctrl+p>arrow_right=goto_split:right"
          "ctrl+p>arrow_down=goto_split:down"
          "ctrl+p>arrow_up=goto_split:up"
          "ctrl+p>x=close_surface"
          "ctrl+p>d=new_split:down"
          "ctrl+p>s=new_split:right"

          # Tab mode ala. zellij
          "ctrl+t>n=new_tab"
          "ctrl+t>x=close_tab"

          "alt+shift+[=goto_tab:1"
          "alt+[=previous_tab"
          "alt+]=next_tab"
          "alt+shift+]=last_tab"
        ];
      # ++ lib.optionals config.programs.zellij.enable [
      #   "ctrl+shift+t=unbind" # spawn tab
      #   "ctrl+shift+w=unbind" # close tab
      #   "ctrl+shift+n=unbind" # open new window
      #   "ctrl+page_up=unbind"
      #   "ctrl+page_down=unbind"
      #   "ctrl+tab=unbind"
      #   "ctrl+shift+tab=unbind"
      #   "ctrl+shift+o=unbind" # open vertical split
      #   "ctrl+shift+e=unbind" # open horizontal split
      #   "ctrl+comma=unbind" # open ghostty config
      #   "ctrl+alt+left=unbind"
      #   "ctrl+shift+a=unbind" # select all text
      #   "ctrl+shift+left=unbind"
      #   "ctrl+shift+right=unbind"
      #   "ctrl+shift+j=unbind" # write screen contents to tmp file
      #   "alt+1=unbind"
      # ];
    };

    # themes = {
    #   # https://github.com/rjshkhr/dotfiles/blob/main/.config/ghostty/themes/shadow.conf
    #   shadow = {
    #     background = "#1D2326";
    #     foreground = "#E6E7E6";
    #     # cursor-color = "";
    #     # selection-background = "";
    #     # selection-foreground = "";
    #     palette = [
    #       "0=#242B2D"
    #       "1=#BC8F7D"
    #       "2=#96B088"
    #       "3=#CCAC7D"
    #       "4=#7E9AAB"
    #       "5=#A68CAA"
    #       "6=#839C98"
    #       "7=#CED3DC"
    #       "8=#485457"
    #       "9=#D4A394"
    #       "10=#ABC49E"
    #       "11=#E2BF8F"
    #       "12=#94B1C4"
    #       "13=#BC9EC0"
    #       "14=#97B3AF"
    #       "15=#E8EBF0"
    #     ];
    #   };
    # };
  };

  home.packages = [
    boo
  ];
}
