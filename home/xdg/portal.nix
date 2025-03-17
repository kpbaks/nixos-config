{ pkgs, ... }:
{
  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  # xdg.portal.config.common.default = "kde";
  xdg.portal.extraPortals = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    xdg-desktop-portal-cosmic
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    # pkgs.kdePackages.kwalletmanager
    # pkgs.xdg-desktop-portal-hyprland
    # pkgs.xdg-desktop-portal-wlr
  ];

  # IDEA: create an app that can generate these files, by analysing which portals the user has installed
  # xdg.portal.config.common.default = "cosmic";

  # xdg.portal.config.cosmic = {
  #   default = [ "cosmic" ];
  #   "org.freedesktop.impl.portal.Secret" = [
  #     "gnome-keyring"
  #   ];
  #   "org.freedesktop.impl.portal.Wallpaper" = [
  #     "gnome"

  #   ];
  #   "org.freedesktop.impl.portal.Remote-Desktop" = [
  #     "gnome"
  #   ];
  #   "org.freedesktop.impl.portal.Print" = [
  #     "gnome"
  #   ];
  #   "org.freedesktop.impl.portal.Email" = [
  #     "gtk"
  #   ];
  # };

  xdg.portal.config.niri = {
    default = "gtk";
    "org.freedesktop.impl.portal.Secret" = [
      "kwallet"
    ];
  };
  # A cool app to test a DE for which portals it support
  # https://flathub.org/apps/com.belmoussaoui.ashpd.demo
  home.packages = with pkgs; [ ashpd-demo ];
}
