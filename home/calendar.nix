{ config, ... }:
{

  accounts.calendar.basePath = config.home.homeDirectory + "/.calendars";
  accounts.calendar.accounts = {
    personal = {
      khal.enable = true;
      khal.color = "yellow";
      primary = true;
      remote = {
        type = "google_calendar";
        password = [ "bw" ];
      };
      vdirsyncer = {
        enable = true;
      };
    };
  };

  programs.khal = {
    enable = true;
    locale =
      let
        monday = 0;
      in
      {
        weeknumbers = "left";
        unicode_symbols = true;
        firstweekday = monday;
      };
    settings =
      let
        highlight_event_days = true;
      in
      {
        default = {
          default_calendar = "Calendar";
          timedelta = "5d"; # how many days to show into the future to show events for
          highlight_event_days = highlight_event_days;
          show_all_days = false;
        };
        view = {
          event_view_always_visible = true;
          frame = "top";
        };
      }
      // (
        if highlight_event_days then
          {
            highlight_days = {
              method = "fg";
              multiple = "yellow";
            };
          }
        else
          { }
      );
  };
}
