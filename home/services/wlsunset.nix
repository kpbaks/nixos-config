{ ... }:
{

  # TODO: configure
  # set screen gamma (aka. night light) based on time of day
  services.wlsunset = {
    enable = true;
    sunrise = "06:30";
    sunset = "18:30";
    temperature.night = 4000;
    temperature.day = 6500;
    # "wlsunset -t 4000 -T 6500 -S 06:30 -s 18:30"
  };
}
