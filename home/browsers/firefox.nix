{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    # TODO: wrap in `web-ext`
    package = pkgs.firefox;
    # package = pkgs.firefox-devedition;
    # TODO: declare extensions here
    # FIXME: does not work
    # enableGnomeExtensions = config.services.gnome-browser-connector.enable;
    policies = {
      DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
    };

    profiles.default = {
      id = 0; # default
      settings = {
        "accessibility.browsewithcaret" = true; # toggled with f7
        "browser.startup.homepage" = "https://nixos.org";
        "browser.search.region" = "DK";
        "browser.search.isUS" = false;
        "distribution.searchplugins.defaultLocale" = "en-DK";
        "general.useragent.locale" = "en-DK";
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.newtabpage.pinned" = [
          {
            title = "NixOS";
            url = "https://nixos.org";
          }
        ];
      };
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   privacy-badger
      # ];
      search.privateDefault = "DuckDuckGo";
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
          iconUpdateURL = "https://wiki.nixos.org/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nw" ];
        };

        "Bing".metaData.hidden = true;
        "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
      };

      userChrome =
        # css
        '''';
      userContent =
        # css
        '''';
    };
  };
}
