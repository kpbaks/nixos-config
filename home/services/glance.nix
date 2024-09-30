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
  widgets.repository.fish-shell = {
    type = "repository";
    repository = "fish-shell/fish-shell";
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
in
{
  # TODO: create dns alias
  # TODO: make more personal
  # use lighter colors: e.g. use catppuccin latte
  services.glance.enable = true;
  services.glance.settings = {
    server.port = 5678;
    server.host = "localhost";
    theme = themes.catppuccin-mocha;
    pages = [
      {
        name = "Work";
        columns = [
          {
            size = "full";
            widgets = with widgets; [
              { type = "calendar"; }
              weather
            ];
          }
        ];
      }
      {
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
      }
      {
        name = "Home";
        columns = [
          {
            size = "small";
            widgets = [
              { type = "calendar"; }
              {
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
              }

              widgets.twitch-channels
            ];
          }
          {
            size = "full";
            widgets =
              let
                subreddit = sub: {
                  subreddit = sub;
                  type = "reddit";
                };
              in
              [
                { type = "hacker-news"; }
                {
                  channels = [
                    "UCR-DXc1voovS8nhAvccRZhg"
                    "UCv6J_jJa8GJqFwQNgNrMuww"
                    "UCOk-gHyjcWZNj3Br4oxwh0A"
                  ];
                  type = "videos";
                }
                (subreddit "rust")
                (subreddit "kde")
                (subreddit "linux")
              ];
          }
          {
            size = "small";
            widgets = with widgets; [
              weather
              {
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
                    (ticker "Bitcoin" "BTC-USD")
                    # (ticker "Reddit" "RDDT")
                  ];
                type = "markets";
              }
            ];
          }
        ];
      }
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
