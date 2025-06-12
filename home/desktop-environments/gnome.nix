{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = osConfig.services.xserver.desktopManager.gnome;
in
{
  home.packages =
    with pkgs.gnomeExtensions;
    [
      forge
      fuzzy-app-search
      tweaks-in-system-menu
      clipboard-indicator
    ]
    ++ (with pkgs; [
    ]);

  # home.packages =
  #   if cfg.enable then
  #     [
  #       (pkgs.writers.writeNuBin "gnome-shell-toggle-night-light" { }
  #         # nu
  #         ''
  #           let key = "org.gnome.settings-daemon.plugins.color night-light-enabled"
  #           let state = ${pkgs.glib}/bin/gsettings get $key | into bool

  #           ${pkgs.glib}/bin/gsettings set $key (not $state)
  #         ''
  #       )
  #     ]
  #   else
  #     [ ];

}
