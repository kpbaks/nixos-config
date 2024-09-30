{ config, pkgs, ... }:
{
  programs.firefox.profiles.personal = {
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
    #   # TODO: fetch userstyles from catppuccin https://github.com/catppuccin/userstyles?tab=readme-ov-file
    #   # and use `config.catppuccin.flavor` to select the specific colorscheme
    #   stylus
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
}
