{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = false;
in
{
  programs.niriswitcher = {
    inherit enable;
    settings = { };
    style = # css
      '''';
  };

  programs.niri.settings.spawn-at-startup = lib.optional enable {
    command = [
      (lib.getExe config.programs.niriswitcher.package)
    ];
  };

  # https://github.com/isaksamsten/niriswitcher#gdbus
  programs.niri.settings.binds =
    if enable then
      (
        with config.lib.niri.actions;
        let
          gdbus = "${pkgs.glib}/bin/gdbus";
        in
        {
          "Alt+Tab" = {
            action =
              spawn "${gdbus}" "call" "--session" "--dest" "io.github.isaksamsten.Niriswitcher" "--object-path"
                "/io/github/isaksamsten/Niriswitcher"
                "--method"
                "io.github.isaksamsten.Niriswitcher.application";

            # hotkey-overlay.title = "";
          };

          "Alt+Shift+Tab" = {
            action =
              spawn "${gdbus}" "call" "--session" "--dest" "io.github.isaksamsten.Niriswitcher" "--object-path"
                "/io/github/isaksamsten/Niriswitcher"
                "--method"
                "io.github.isaksamsten.Niriswitcher.application";
            # hotkey-overlay.title = "";
          };
        }
      )
    else
      { };
}
