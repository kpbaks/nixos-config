{
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      anchor = "top-left";
      border-radius = 4;
      font = "monospace 12";
      icons = true;
      ignore-timeout = false;
      # layer = "top";
      layer = "overlay"; # appear on top of full-screen windows
      margin = 10;
      padding = 10;
      markup = true;
      sort = "-time";
      border-size = 2;
      default-timeout = 5000;
      on-button-left = "invoke-default-action";
      on-button-middle = "dismiss-group";
      on-button-right = "dismiss";
      on-touch = "invoke-default-action";
      width = 500; # px
      # height = 100;
      # on-notify="exec mpv /usr/share/sounds/freedesktop/stereo/message.oga";
      progress-color = "over #0b1c1c";
      "urgency=low".border-color = "#cccccc";
      "urgency=normal".border-color = "#d08770";
      "urgency=high" = {
        border-color = "#bf616a";
        default-timeout = 0;
      };

      "category=mpd" = {
        default-timeout = 2000;
        group-by = "category";
      };

      "actionable=true" = {
        anchor = "top-right";
      };
    };
  };

  # TODO:
  # NOTE: mako uses dbus activation https://specifications.freedesktop.org/desktop-entry-spec/latest/dbus.html
  # So we have to configure it to run as a systemd service, in order to conditionally enable when the desktop
  # is not something like kde plasma or gnome.

  # Modify service definition to enable in a tiling WM like niri, but
  # disable in when using KDE Plasma.
  # [ref:set_XDG_CURRENT_DESKTOP_to_niri]
  # systemd.user.services.mako = {
  #   User.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
  # };
}
