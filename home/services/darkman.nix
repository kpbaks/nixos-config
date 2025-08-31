{
  config,
  lib,
  pkgs,
  ...
}:
let
  gtk-theme = light-or-dark: ''
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-${light-or-dark}'"
  '';
  fish-shell-theme = light-or-dark: ''
    # Use `fish_config theme list` to get list of installed themes
    if [[ "${light-or-dark}" = "light" ]]; then
      theme="ayu Light"
    else
      theme="ayu Dark"
    fi

    ${config.programs.fish.package}/bin/fish --no-config -c "yes | fish_config theme save '$theme'"
  '';
  desktop-notification = light-or-dark: ''
    if [[ "${light-or-dark}" = "light" ]]; then
      icon="weather-clear"
    else
      icon="weather-clear-night"
    fi

    ${pkgs.libnotify}/bin/notify-send --app-name="darkman" --urgency=low --icon="$icon" "switching to ${light-or-dark} mode"
  '';

in
{
  # FIXME: does not do anything
  services.darkman = {
    enable = true;
    settings = {
      lat = 56.15; # Aarhus
      lon = 10.2; # Aarhus
      portal = true;
      usegeoclue = true;
      dbusserver = true;
    };
    # TODO: change qt apps
    darkModeScripts = {
      gtk-theme = gtk-theme "dark";
      fish-shell-theme = fish-shell-theme "dark";
      desktop-notification = desktop-notification "dark";
    };
    lightModeScripts = {
      gtk-theme = gtk-theme "light";
      fish-shell-theme = fish-shell-theme "light";
      desktop-notification = desktop-notification "light";
    };
  };

  systemd.user.services.darkman = {
    Unit.ConditionEnvironment = lib.mkForce [
      "XDG_CURRENT_DESKTOP=niri"
    ];
  };
}
