{
  config,
  lib,
  ...
}:
let
  enable = true;
in
{
  services.copyq = {
    inherit enable;
    # FIXME: does not work
    systemdTarget = "niri-session.target";
  };
  # Modify service definition to enable in a tiling WM like niri, but
  # disable in when using KDE Plasma.
  # [ref:set_XDG_CURRENT_DESKTOP_to_niri]
  systemd.user.services.copyq = {
    User.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
  };

  programs.niri.settings.window-rules = lib.optional enable {
    matches = [ { app-id = "com.github.hluk.copyq"; } ];
    block-out-from = "screencast";
    # block-out-from = "screen-capture";
    open-floating = true;
    open-focused = true;
    default-floating-position = {
      x = 100;
      y = 200;
      relative-to = "top-left";
    };
  };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    # Same keybind as in kde plasma
    "Mod+V".action = spawn "${config.services.copyq.package}/bin/copyq" "show";
  };
}
