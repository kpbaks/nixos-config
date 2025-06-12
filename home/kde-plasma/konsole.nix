{
  config,
  lib,
  pkgs,
  ...
}:
# user-defined-stylesheet-path = "konsole/stylesheets/default.css"; # relative to ~/.config/
{
  programs.konsole.enable = true;
  programs.konsole.defaultProfile = "Personal";

  programs.konsole.profiles.Personal = {
    command = "${config.programs.fish.package}/bin/fish";
    # command = "${pkgs.fish}/bin/fish";
    # colorScheme = "catppuccin-${config.catppuccin.flavor}";
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };
    extraConfig = {
      General = {
        SemanticHints = 2;
        SemanticInputClick = true;
        SemanticUpDown = true;
      };

      "Interaction Options" = {
        AllowEscapedLinks = true;
        AutoCopySelectedText = true;
        CopyTextAsHTML = false;
        OpenLinksByDirectClickEnabled = true;
        TrimLeadingSpacesInSelectedText = true;
        TrimTrailingSpacesInSelectedText = true;
        UnderlineFilesEnabled = true;
      };

      "Terminal Features" = {
        LineNumbers = 1;
      };

      #       [TabBar]
      "TabBar" = {
        CloseTabOnMiddleMouseButton = true;
        ExpandTabWidth = true;
        TabBarUseUserStyleSheet = true;
        # TabBarUserStyleSheetFile = "file:///home/kpbaks/Desktop/foo.css";
        # TabBarUserStyleSheetFile = "file://${config.xdg.configHome}/${user-defined-stylesheet-path}";
      };
    };
  };

  # programs.konsole.customColorSchemes =
  #   lib.pipe
  #     [
  #       "frappe"
  #       "mocha"
  #       "latte"
  #       "macchiato"
  #     ]
  #     [
  #       (map (theme: "catppuccin-${theme}"))
  #       (map (name: {
  #         inherit name;
  #         # value = /. + "${catppuccin-konsole}/themes/${name}.colorscheme";
  #         # value = "${catppuccin-konsole}/themes/${name}.colorscheme";
  #       }))
  #       builtins.listToAttrs
  #     ];

  # xdg.configFile."konsole/stylesheets/default.css".text = # css
  # TODO: use catppuccin colors and jetbrains mono font
  # xdg.configFile.${user-defined-stylesheet-path}.text = # css
  #   ''
  #     QTabBar {
  #       background: #EFF0F1;
  #       padding-bottom: 10px;
  #     }

  #     QTabBar::tab {
  #       background: #ff0000;
  #       padding: 18px;
  #       border-bottom: 2px solid transparent;

  #       font-size: 14px;
  #       color: #31363B;
  #     }

  #     QTabBar::tab:hover {
  #       border-bottom: 2px solid rgba(0, 0, 0, 0.12);
  #     }

  #     QTabBar::tab:selected {
  #       border-bottom: 2px solid rgba(0, 0, 0, 1);
  #     }

  #   '';
}
