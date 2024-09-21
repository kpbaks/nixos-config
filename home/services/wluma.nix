{ pkgs, ... }:
{
  home.packages = [ pkgs.wluma ];

  # TODO: upstream to `https://github.com/nix-community/home-manager`
  # https://github.com/maximbaz/wluma/blob/main/config.toml
  xdg.configFile."wluma/config.toml".text =
    # toml
    ''
      [als.time]
      thresholds = { 0 = "night", 7 = "dark", 9 = "dim", 11 = "normal", 13 = "bright", 16 = "normal", 18 = "dark", 20 = "night" }

      [[output.backlight]]
      name = "eDP-1"
      path = "/sys/class/backlight/intel_backlight"
      capturer = "wlroots"
    '';
}
