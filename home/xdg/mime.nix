# { pkgs, ... }:
{
  # xdg.mime.addedAssociations = ;

  # xdg-mime query default image/svg+xml

  # TODO: find way to validate that all *.desktop files exist for each mime-type
  # https://www.reddit.com/r/linuxquestions/comments/iypx8k/where_does_xdgmime_store_its_actual_default_app/
  # ~/.config/mimeapps.list
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications =
    #   let
    #     # loupe = "org.gnome.Loupe.desktop";
    #     # browser = "firefox.desktop";
    #     browser = "dev.zed.Zed.desktop";
    #     okular = "org.kde.okular.desktop";
    #     gwenview = "org.kde.gwenview.desktop";
    #     zathura = "org.pwmt.zathura.desktop";
    #     image-viewer = gwenview;
    #   in
    {

      "application/rss+xml" = [
        "thunderbird.desktop"
      ];
      #     "application/pdf" = [
      #       okular
      #       zathura
      #     ];
      #     "text/html" = [ browser ];
      #     "image/svg+xml" = [ browser ];
      #     "image/png" = [ image-viewer ];
      #     "image/jpeg" = [ image-viewer ];
      #     "image/webp" = [ image-viewer ];
      #     # "inode/directory" = [ "yazi.desktop" ];
      #     # TODO: add to `home/flatpak.nix` instead
      #     # TODO: create a program that opens the terminal and runs `flatpak install <remote> <flatpak-id>` in it, from parsing the ref
      #     # /home/kpbaks/.var/app/io.github.zen_browser.zen/cache/tmp/mozilla_kpbaks0/de.hummdudel.Libellus.flatpakref
      #     # "application/vnd.flatpak.ref" =
      #     # TODO: create a cool handler

      #     # "application/x-ipynb+json"
      #     # TODO: create .desktop for `jnv`
      #     # "application/json" = [jnv];
    };
}
