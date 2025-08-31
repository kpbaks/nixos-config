{ config, ... }:
let
  remaining-column-width-proportion =
    1.0 - config.programs.niri.settings.layout.default-column-width.proportion;
  browser = "^(firefox|zen).*";
in
{

  programs.niri.settings.window-rules = [
    { draw-border-with-background = false; }
    {
      # https://github.com/YaLTeR/niri/wiki/Application-Issues#wezterm
      matches = [ { app-id = ''^org\.wezfurlong\.wezterm$''; } ];
      default-column-width = { };
    }

    {
      matches = [ { app-id = "Bitwarden"; } ];
      block-out-from = "screencast";
      # block-out-from = "screen-capture";
    }

    {
      # TODO: add more rules
      # FIXME: does not match private browsing in firefox
      matches = [
        {
          app-id = browser;
          title = ".*Private Browsing$";
        }
      ];
      border.active.color = "purple";
    }
    {
      matches = [
        {
          app-id = "thunderbird";
          title = "^\d+ Reminders?$";
        }
        {
          # Pops up when running `run0 <program>`
          app-id = "^org.kde.polkit-kde-authentication-agent-1$";
        }

        {
          app-id = "^firefox$";
          # title = "Extension: \(Bitwarden Password Manager\) - Bitwarden";
          title = "Extension:.*- Bitwarden";
        }
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
        {
          app-id = "okular";
          title = "^New Text Note.*";
        }
        { app-id = "^org.freedesktop.impl.portal.desktop.kde$"; }
      ];

      # default-column-width.proportion = remaining-column-width-proportion;
      open-floating = true;
    }

    {
      matches = [
        {
          app-id = "kitty";
          title = "^/";
        }
      ];
      border.active.color = "red";
    }
    {
      # Open the Firefox Picture-in-Picture window at the bottom-left corner of the screen
      matches = [
        {
          app-id = "firefox$";
          title = "^Picture-in-Picture$";
        }
      ];
      open-floating = true;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "bottom-left";
      };
    }
    {
      matches = [
        { title = "^Extension: (Bitwarden Password Manager).+"; }
      ];
      open-floating = true;
      open-focused = true;
      block-out-from = "screencast";
    }
    {
      matches = [
        {
          app-id = "^org.telegram.desktop$";
          at-startup = true;
        }
        {
          app-id = "^vesktop$";
          at-startup = true;
        }
      ];
      open-on-workspace = "chat";
    }
    {
      matches = [
        {
          app-id = "^dev.zed.Zed$";
          at-startup = true;
        }
        {
          app-id = "^org.kate.Kate$";
          at-startup = true;
        }
      ];
      open-on-workspace = "development";
    }
    {
      matches = [
        {
          app-id = "^thunderbird$";
          at-startup = true;
        }
      ];
      open-on-workspace = "mail";
    }
  ];
}
