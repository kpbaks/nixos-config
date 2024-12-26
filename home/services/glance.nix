# TODO: finish pr to upstream catppuccin colors

{ config, pkgs, ... }:

let
  # https://github.com/glanceapp/glance/blob/main/docs/themes.md#catppuccin-mocha
  themes.catppuccin-mocha = {
    background-color = "240 21 15";
    contrast-multiplier = 1.2;
    primary-color = "217 92 83";
    positive-color = "115 54 76";
    negative-color = "347 70 65";
  };
  widgets.group = widgets: {
    type = "group";
    inherit widgets;
  };

  widgets.clock = {
    type = "clock";
    hour-format = "24h";
    timezones = [
      {
        timezone = "Europe/Copenhagen";
        label = "Copenhagen";
      }
      {
        timezone = "America/New_York";
        label = "New York";
      }
      {
        timezone = "Asia/Tokyo";
        label = "Tokyo";
      }
      {
        timezone = "America/Los_Angeles";
        label = "Los Angeles";
      }
    ];
  };
  widgets.reddit = {
    type = "group";
    widgets = [
      {
        type = "reddit";
        subreddit = "rust";
        show-thumbnails = true;
        collapse-after = 6;
      }
      {
        type = "reddit";
        subreddit = "games";
      }
    ];
  };
  widgets.releases = {
    type = "releases";
    show-source-icon = true;
    repositories = [
      "yaLTeR/niri"
      "helix-editor/helix"
      "fish-shell/fish-shell"
      "nushell/nushell"
      "gitlab:fdroid/fdroidclient"
    ];
  };
  widgets.repository.__functor = _self: owner: repo: {
    type = "repository";
    repository = "${owner}/${repo}";
    pull-requests-limit = 5;
    issues-limit = 3;
    commits-limit = 3;
  };
  widgets.repository.fish-shell = {
    type = "repository";
    repository = "fish-shell/fish-shell";
    pull-requests-limit = 5;
    issues-limit = 3;
    commits-limit = 3;
  };
  widgets.repository.helix = {
    type = "repository";
    repository = "helix-editor/helix";
    pull-requests-limit = 5;
    issues-limit = 3;
    commits-limit = 3;
  };

  widgets.search = {
    type = "search";
    search-engine = "duckduckgo"; # "duckduckgo" | "google"
    autofocus = true;
    bangs = [
      {
        title = "YouTube";
        shortcut = "!yt";
        url = "https://www.youtube.com/results?search_query={QUERY}";
      }
    ];
  };
  widgets.twitch-channels = {
    type = "twitch-channels";
    channels = [
      "theprimeagen"
      "teej_dv"
      "tsoding"
      "louispilfold"
      "jonhoo"
      "criticalrole"
      "peachoncan"
      # "cohhcarnage"
    ];
  };

  widgets.twitch-top-games = {
    type = "twitch-top-games";
    exclude = [
      "just-chatting"
      "pools-hot-tubs-and-beaches"
      "music"
      "art"
      "asmr"
    ];
  };
  widgets.weather = {
    type = "weather";
    location = "Aarhus, Denmark";
    unit = "metric";
    hour-format = "24h";
    show-area-name = true;
  };
  widgets.calendar = {
    type = "calendar";
  };
  widgets.hacker-news.type = "hacker-news";
  widgets.subreddit = subreddit: {
    inherit subreddit;
    type = "reddit";
  };
  # widgets.reddit.software-development = {
  #         let
  #           subreddit = sub: {
  #             subreddit = sub;
  #             type = "reddit";
  #           };
  #         in
  #           # { type = "hacker-news"; }
  #           {
  #             channels = [
  #               "UCR-DXc1voovS8nhAvccRZhg"
  #               "UCv6J_jJa8GJqFwQNgNrMuww"
  #               "UCOk-gHyjcWZNj3Br4oxwh0A"
  #             ];
  #             type = "videos";
  #           }
  #           (subreddit "rust")
  #           (subreddit "kde")
  #           (subreddit "linux")

  # };

  widgets.markets = {
    markets =
      let
        ticker = name: symbol: { inherit name symbol; };
      in
      [
        (ticker "S&P 500" "SPY")
        (ticker "NVIDIA" "NVDA")
        (ticker "AMD" "AMD")
        (ticker "Intel" "INTC")
        (ticker "Apple" "AAPL")
        (ticker "Microsoft" "MSFT")
        (ticker "Google" "GOOGL")
        # (ticker "Bitcoin" "BTC-USD")
        # (ticker "Reddit" "RDDT")
      ];
    type = "markets";
  };

  # - name: Startpage
  #   width: slim
  #   hide-desktop-navigation: true
  #   center-vertically: true
  #   columns:
  #     - size: full
  #       widgets:
  #         - type: search
  #           autofocus: true

  #         - type: monitor
  #           cache: 1m
  #           title: Services
  #           sites:
  #             - title: Jellyfin
  #               url: https://yourdomain.com/
  #               icon: si:jellyfin
  #             - title: Gitea
  #               url: https://yourdomain.com/
  #               icon: si:gitea
  #             - title: qBittorrent # only for Linux ISOs, of course
  #               url: https://yourdomain.com/
  #               icon: si:qbittorrent
  #             - title: Immich
  #               url: https://yourdomain.com/
  #               icon: si:immich
  #             - title: AdGuard Home
  #               url: https://yourdomain.com/
  #               icon: si:adguard
  #             - title: Vaultwarden
  #               url: https://yourdomain.com/
  #               icon: si:vaultwarden

  #         - type: bookmarks
  #           groups:
  #             - title: General
  #               links:
  #                 - title: Gmail
  #                   url: https://mail.google.com/mail/u/0/
  #                 - title: Amazon
  #                   url: https://www.amazon.com/
  #                 - title: Github
  #                   url: https://github.com/
  #             - title: Social
  #               links:
  #                 - title: Reddit
  #                   url: https://www.reddit.com/
  #                 - title: Twitter
  #                   url: https://twitter.com/
  #                 - title: Instagram
  #                   url: https://www.instagram.com/
  widgets.bookmarks = {
    type = "bookmarks";
    groups =
      let
        link = title: url: { inherit title url; };
      in

      [
        {
          title = "General";
          links = [
            {
              title = "Gmail";
              url = "https://mail.google.com/mail/u/0/";
            }
            {
              title = "Amazon";
              url = "https://www.amazon.com/";
            }
            {
              title = "Github";
              url = "https://github.com/";
            }
          ];
        }

        {

          title = "Entertainment";
          links = [
            {
              title = "YouTube";
              url = "https://www.youtube.com/";
            }
            {
              title = "Prime Video";
              url = "https://www.primevideo.com/";
            }
            {
              title = "Disney+";
              url = "https://www.disneyplus.com/";
            }
          ];
        }

        {

          title = "Social";
          links = [
            (link "Reddit" "https://www.reddit.com/")
            (link "Instagram" "https://www.instagram.com/")
          ];
        }
      ];
  };

  widgets.rss = {
    cache = "3h";
    collapse-after = 3;
    feeds = [
      # { url = "https://ciechanow.ski/atom.xml"; }
      # {
      #   title = "Josh Comeau";
      #   url = "https://www.joshwcomeau.com/rss.xml";
      # }
      # { url = "https://samwho.dev/rss.xml"; }
      # { url = "https://awesomekling.github.io/feed.xml"; }
      # {
      #   title = "Ahmad Shadeed";
      #   url = "https://ishadeed.com/feed.xml";
      # }
    ];
    limit = 10;
    type = "rss";
  };
  pages.work = {
    name = "Work";
    columns = [
      {
        size = "full";
        widgets = with widgets; [
          calendar
          weather
        ];
      }
    ];
  };
  pages.gaming = {
    name = "Gaming";
    columns = [
      {
        size = "full";
        widgets = with widgets; [
          twitch-channels
          twitch-top-games
        ];
      }
    ];
  };

  pages.open-source = {
    name = "Open Source";
    columns = [
      {
        size = "full";
        widgets = with widgets; [
          # FIXME: suggest pr to have a repositories name in the tab bar when in a group widget
          (group [
            repository.fish-shell
            repository.helix
            (repository "glanceapp" "glance")
          ])
        ];
      }
      {
        size = "small";
        widgets = with widgets; [
          releases

        ];
      }

    ];
  };

  pages.start-page = {
    name = "Startpage";
    width = "slim";
    hide-desktop-navigation = false;
    center-vertically = true;
    columns = [
      {
        size = "full";
        widgets = with widgets; [
          search
          bookmarks
        ];
      }
    ];
  };

  pages.home = {

    name = "Home";
    columns = [
      {
        size = "small";
        widgets = with widgets; [
          weather
          calendar
          markets
        ];
      }
      {
        size = "full";
        widgets = with widgets; [
          search
          (group [
            (subreddit "kde")
            (subreddit "rust")
            (subreddit "linux")
            (subreddit "news")
          ])
          # rss
        ];
      }
    ];

  };
in
{
  # TODO: create dns alias
  # TODO: make more personal
  # use lighter colors: e.g. use catppuccin latte
  services.glance.enable = false;
  services.glance.settings = {
    # TODO: have zen browser read this variable when its hm module is ready
    server.port = 5678;
    server.host = "localhost";
    theme = themes.catppuccin-mocha;
    pages = with pages; [
      start-page
      home
      work
      gaming
      open-source
    ];
  };
  # logo url: https://avatars.githubusercontent.com/u/159397742?s=200&v=4
  xdg.desktopEntries.glance =
    let
      server = config.services.glance.settings.server;
      port = builtins.toString server.port;
      addr = "http://${server.host}:${port}";
    in
    {
      name = "Glance";
      type = "Application";
      exec = "${pkgs.xdg-utils}/bin/xdg-open ${addr}";
      terminal = false;
      categories = [ "System" ];
      #   actions.open =
      #     {
      #       exec = "${pkgs.xdg-utils}/bin/xdg-open ${addr}";
      #     };
    };
}
