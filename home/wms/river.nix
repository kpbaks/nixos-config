{ ... }:
{
  wayland.windowManager.river = {
    # enable = osConfig.programs.river.enable;
    enable = false;
    xwayland.enable = true;
    extraSessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
    settings = {
      map = {
        normal = {
          "Alt Q" = "close";
        };
      };
    };

    extraConfig = ''
      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}
