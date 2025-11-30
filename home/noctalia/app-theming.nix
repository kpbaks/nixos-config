# https://docs.noctalia.dev/configuration/app-theming/#gtk
{ pkgs, ... }:
{
  home.packages = with pkgs; [ qt6Packages.qt6ct ];

  # https://docs.noctalia.dev/configuration/app-theming/#gtk
  # gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
  dconf.settings."org.gnome.desktop.interface".gtk-theme = "adw-gtk3";
  programs.niri.settings = {
    environment = {
      # https://docs.noctalia.dev/configuration/app-theming/#qt
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };
  };
}
