{ pkgs, ... }:
{

  xdg.enable = true;
  xdg.userDirs.createDirectories = false;
  # xdg.dataFile."nix-snowflake-colours.svg".source = ./nix-snowflake-colours.svg;

  # xdg-mime query default image/svg+xml
  # xdg.mimeApps.enable = true;
  # TODO: find way to validate that all *.desktop files exist for each mime-type
  # https://www.reddit.com/r/linuxquestions/comments/iypx8k/where_does_xdgmime_store_its_actual_default_app/
  # ~/.config/mimeapps.list
  xdg.mimeApps.defaultApplications =
    let
      loupe = "org.gnome.Loupe.desktop";
      # browser = "firefox.desktop";
      browser = "dev.zed.Zed.desktop";
      okular = "org.kde.okular.desktop";
      gwenview = "org.kde.gwenview.desktop";
      zathura = "org.pwmt.zathura.desktop";
      image-viewer = gwenview;
    in
    {
      "application/pdf" = [
        okular
        zathura
      ];
      "text/html" = [ browser ];
      "image/svg+xml" = [ browser ];
      "image/png" = [ image-viewer ];
      "image/jpeg" = [ image-viewer ];
      "image/webp" = [ image-viewer ];
      "inode/directory" = [ "yazi.desktop" ];
      # TODO: create a cool handler

      # "application/x-ipynb+json" 
      # TODO: create .desktop for `jnv`
      # "application/json" = [jnv];
    };

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.config.common.default = "kde";
  xdg.portal.extraPortals = [
    # pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-kde
    # pkgs.xdg-desktop-portal-hyprland
    # pkgs.xdg-desktop-portal-wlr
    # pkgs.xdg-desktop-portal-cosmic
  ];

}
