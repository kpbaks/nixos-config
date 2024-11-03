# A cool app to test a DE for which portals it support
# https://flathub.org/apps/com.belmoussaoui.ashpd.demo
{ pkgs, ... }:
{
  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  # xdg.portal.config.common.default = "kde";
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-kde
    pkgs.xdg-desktop-portal-cosmic
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-gnome
    pkgs.gnome-keyring
    # pkgs.kdePackages.kwalletmanager
    # pkgs.xdg-desktop-portal-hyprland
    # pkgs.xdg-desktop-portal-wlr
  ];

  # IDEA: create an app that can generate these files, by analysing which portals the user has installed
  xdg.portal.config.common.default = "cosmic";

  xdg.portal.config.cosmic = {
    default = [ "cosmic" ];
    "org.freedesktop.impl.portal.Secret" = [
      "gnome-keyring"
    ];
    "org.freedesktop.impl.portal.Wallpaper" = [
      "gnome"

    ];
    "org.freedesktop.impl.portal.Remote-Desktop" = [
      "gnome"
    ];
    "org.freedesktop.impl.portal.Print" = [
      "gnome"
    ];
    "org.freedesktop.impl.portal.Email" = [
      "gtk"
    ];
  };

  xdg.portal.config.niri = {
    default = "gtk";
  };
}
