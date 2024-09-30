{
  config,
  lib,
  pkgs,
  ...
}:
let
  catppuccin-konsole = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "konsole";
    rev = "3b64040e3f4ae5afb2347e7be8a38bc3cd8c73a8";
    hash = "sha256-d5+ygDrNl2qBxZ5Cn4U7d836+ZHz77m6/yxTIANd9BU=";
  };
in
{
  programs.konsole.enable = true;
  programs.konsole.defaultProfile = "Personal";

  programs.konsole.profiles.Personal = {
    command = "${pkgs.fish}/bin/fish";
    colorScheme = "catppuccin-${config.catppuccin.flavor}";
    font = {
      name = "JetBrains Nerd Font Mono";
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
    };
  };

  programs.konsole.customColorSchemes =
    lib.pipe
      [
        "frappe"
        "mocha"
        "latte"
        "macchiato"
      ]
      [
        (map (theme: "catppuccin-${theme}"))
        (map (name: {
          inherit name;
          # value = /. + "${catppuccin-konsole}/themes/${name}.colorscheme";
          value = "${catppuccin-konsole}/themes/${name}.colorscheme";
        }))
        builtins.listToAttrs
      ];
}
