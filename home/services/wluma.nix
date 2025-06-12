{
  config,
  lib,
  pkgs,
  ...
}:
{

  # FIXME(Sun Sep 22 09:04:00 PM CEST 2024): `niri` does not support `export_dmabuf_manager` protocol
  # which is needed.
  # https://wayland.app/protocols/wlr-export-dmabuf-unstable-v1
  # `RUST_LOG=debug wluma`
  # "Unable to init export_dmabuf_manager: Missing"
  services.wluma = {
    enable = true;
    systemd.enable = true;
    # TODO: find the target for niri
    # systemd.target = "sway-session.target";
    settings = {
      als.time = {
        thresholds = {
          "0" = "night";
          "7" = "dark";
          "9" = "dim";
          "11" = "normal";
          "13" = "bright";
          "16" = "normal";
          "18" = "dark";
          "20" = "night";
        };
      };
      # als.webcam = {
      #   video = 0;
      #   thresholds = {
      #     "0" = "night";
      #     "15" = "dark";
      #     "30" = "dim";
      #     "45" = "normal";
      #     "60" = "bright";
      #     "75" = "outdoors";
      #   };
      # };

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
  };

  # # TODO: use the new home-manager module `services.wluma`
  # # https://github.com/maximbaz/wluma/blob/main/wluma.service
  # # Modify service definition to enable in a tiling WM like niri, but
  # # disable in when using KDE Plasma.
  # # [ref:set_XDG_CURRENT_DESKTOP_to_niri]
  # # systemd.user.services.mako = {
  # #   User.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
  # # };
  # systemd.user.services.wluma = {
  #   Unit = {
  #     Description = "Adjusting screen brightness based on screen contents and amount of ambient light";
  #     PartOf = [ "graphical-session.target" ];
  #     After = [ "graphical-session.target" ];

  #   };

  #   Service = {
  #     ExecStart = "${pkgs.wluma}/bin/wluma";
  #     Restart = "always";
  #     EnvironmentFile = "-%E/wluma/service.conf";
  #     PrivateNetwork = true;
  #     PrivateMounts = false;
  #   };

  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
}
