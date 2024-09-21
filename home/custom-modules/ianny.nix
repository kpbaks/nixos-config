{ pkgs, ... }:
{
  home.packages = with pkgs; [ ianny ];

  xdg.configFile."io.github.zefr0x.ianny/config.toml".text =
    # toml
    ''
      # time is given in seconds
      [timer]
      idle_timeout = 240
      short_break_timeout = 1200
      long_break_timeout = 3840
      short_break_duration = 120
      long_break_duration = 240

      [notification]
      show_progress_bar = true
      minimum_update_delay = 1
    '';
}
