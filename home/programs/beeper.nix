{ pkgs, ... }:
{

  home.packages = with pkgs; [ beeper ];

  # TODO: remove when it is no longer needed to wrap Beeper in a xwayland sandbox, on niri man  2 sep 19:18:05 CEST 2024
  # Override the .desktop file that comes with `pkgs.beeper` as it does not work out of the box in `niri` due to missing Xwayland support.
  xdg.desktopEntries.beeper = {
    name = "Beeper";
    exec = "${pkgs.cage}/bin/cage -- ${pkgs.beeper}/bin/beeper --no-sandbox %U";
    terminal = false;
    type = "Application";
    icon = "beeper";
    # https://specifications.freedesktop.org/menu-spec/latest/category-registry.html#main-category-registry
    categories = [
      # "Utility"
      "Network"
    ];
    comment = "Beeper: Unified Messenger";
    settings = {
      StartupWMClass = "Beeper";
    };
  };
}
