{
  config,
  lib,
  pkgs,
  ...
}:
{

  # options.services.wluma = {
  #   enable = lib.mkEnableOption "enable wluma";
  # };

  # FIXME(Sun Sep 22 09:04:00 PM CEST 2024): `niri` does not support `export_dmabuf_manager` protocol
  # which is needed.
  # https://wayland.app/protocols/wlr-export-dmabuf-unstable-v1
  # `RUST_LOG=debug wluma`
  # "Unable to init export_dmabuf_manager: Missing"
  home.packages = [ pkgs.wluma ];

  # TODO: upstream to `https://github.com/nix-community/home-manager`
  # https://github.com/maximbaz/wluma/blob/main/config.toml

  # FIXME: `wluma` cannot parse this
  xdg.configFile."wluma/config.toml".source = (pkgs.formats.toml { }).generate "wluma-config" {
    # als.time = {
    #   thresholds = {
    #     "0" = "night";
    #     "7" = "dark";
    #     "9" = "dim";
    #     "11" = "normal";
    #     "13" = "bright";
    #     "16" = "normal";
    #     "18" = "dark";
    #     "20" = "night";
    #   };
    # };

    als.webcam = {
      video = 0;
      thresholds = {
        "0" = "night";
        "15" = "dark";
        "30" = "dim";
        "45" = "normal";
        "60" = "bright";
        "75" = "outdoors";
      };
    };

    output.backlight = [
      {
        name = "eDP-1";
        path = "/sys/class/backlight/intel_backlight";
        capturer = "wayland";
        # capturer = "wlroots";
      }
    ];
    output.ddcutil = [
      {
        name = "Acer Technologies K272HUL T6AEE0058502";
        capturer = "wayland";
      }
    ];

  };

  # xdg.configFile."wluma/config.toml".text =
  #   # toml
  #   ''
  #     [als.time]
  #     thresholds = { 0 = "night", 7 = "dark", 9 = "dim", 11 = "normal", 13 = "bright", 16 = "normal", 18 = "dark", 20 = "night" }

  #     [als.webcam]
  #     video = 0
  #     thresholds = { 0 = "night", 15 = "dark", 30 = "dim", 45 = "normal", 60 = "bright", 75 = "outdoors" }

  #     [[output.backlight]]
  #     name = "eDP-1"
  #     path = "/sys/class/backlight/intel_backlight"
  #     capturer = "wlroots"

  #     [[output.ddcutil]]
  #     name = "Acer Technologies K272HUL T6AEE0058502"
  #     capturer = "none"
  #   '';

  # https://github.com/maximbaz/wluma/blob/main/wluma.service
  systemd.user.services.wluma = {
    Unit = {
      Description = "Adjusting screen brightness based on screen contents and amount of ambient light";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];

    };

    Service = {
      ExecStart = "${pkgs.wluma}/bin/wluma";
      Restart = "always";
      EnvironmentFile = "-%E/wluma/service.conf";
      PrivateNetwork = true;
      PrivateMounts = false;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
