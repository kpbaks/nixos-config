{ pkgs, ... }:
{
  # TODO: create dns alias
  # TODO: make more personal
  # use lighter colors: e.g. use catppuccin latte
  services.glance.enable = true;
  services.glance.settings = {
    server.port = 5678;
    server.host = "localhost";
    pages = [
      {
        columns = [
          {
            size = "small";
            widgets = [
              { type = "calendar"; }
              {
                cache = "3h";
                collapse-after = 3;
                feeds = [
                  { url = "https://ciechanow.ski/atom.xml"; }
                  {
                    title = "Josh Comeau";
                    url = "https://www.joshwcomeau.com/rss.xml";
                  }
                  { url = "https://samwho.dev/rss.xml"; }
                  { url = "https://awesomekling.github.io/feed.xml"; }
                  {
                    title = "Ahmad Shadeed";
                    url = "https://ishadeed.com/feed.xml";
                  }
                ];
                limit = 10;
                type = "rss";
              }
              {
                channels = [
                  "theprimeagen"
                  "teej_dv"
                  "peachoncan"
                  "cohhcarnage"
                ];
                type = "twitch-channels";
              }
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
                (subreddit "linux")
              ];
          }
          {
            size = "small";
            widgets = [
              {
                location = "Aarhus, Denmark";
                type = "weather";
              }
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
        name = "Home";
      }
    ];
  };
}
