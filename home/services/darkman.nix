{ pkgs, ... }:
{
  # FIXME: does not do anything
  services.darkman = {
    enable = false;
    settings = {
      # lat = 56.15; # Aarhus
      # lon = 10.2; # Aarhus
      portal = true;
      usegeoclue = true;
      dbusserver = true;
    };
    # TODO: change fish color theme
    # TODO: change qt apps
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
      desktop-notification = ''
        ${pkgs.libnotify}/bin/notify-send --app-name="darkman" --urgency=low --icon=weather-clear-night "switching to dark mode"
      '';
    };
    # TODO: change fish color theme
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
      desktop-notification = ''
        ${pkgs.libnotify}/bin/notify-send notify-send --app-name="darkman" --urgency=low --icon=weather-clear "switching to light mode"
      '';
    };
  };

}
