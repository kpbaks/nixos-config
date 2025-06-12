{
  # set screen gamma (aka. night light) based on time of day
  services.wlsunset = {
    enable = true;
    # sunrise = "06:30";
    # sunset = "18:30";
    # Aarhus coordinates
    latitude = 56.15674;
    longitude = 10.21076;
    # gamma = 0.6;
    temperature.night = 3500;
    temperature.day = 6500;
    # systemdTarget = "graphical-session.target";
    systemdTarget = "xdg-desktop-autostart.target";
    # "wlsunset -t 4000 -T 6500 -S 06:30 -s 18:30"
  };

  # Modify service definition to enable in a tiling WM like niri, but
  # disable in when using KDE Plasma.
  # [ref:set_XDG_CURRENT_DESKTOP_to_niri]
  systemd.user.services.wlsunset = {
    User.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
  };
}
