{ config, pkgs, ... }:

let
  remaining-column-width-proportion =
    1.0 - config.programs.niri.settings.layout.default-column-width.proportion;
  browser = "^(firefox|zen).*";
in
{

  programs.niri.settings.window-rules = [
    {
      matches = [
        {
          app-id = "^.?scrcpy(-wrapped)?$";
          at-startup = true;
        }
        {
          app-id = browser;
          title = "Picture-in-Picture";
        }
        {
          app-id = browser;
          title = "^Extension: \(Bitwarden Password Manager\) - Bitwarden$";
        }
        {
          app-id = "org.kde.konsole";
          title = "^Configure — Konsole";
        }
      ];

      default-column-width.proportion = remaining-column-width-proportion;
    }

  ];
}
