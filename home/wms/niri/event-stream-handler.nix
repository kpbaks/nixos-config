# Actions in response to certain conditions:
# 1. Moving to an empty workspace will open fuzzel/application-launcher
# 2. Spawning a new, non floating, window on an empty workspace, will maximize it
# 3. Spawning a new window on a workspace with a single window, that has been maximized by [2.]
#    will de maximize the first window to create a 0.5|0.5 layout
{
  config,
  lib,
  pkgs,
  ...
}:
let
  niri = lib.getExe config.programs.niri.package;
  niri-event-stream-handler = pkgs.writers.writeNuBin "niri-event-stream-handler" { } ''

    job spawn {
      ${niri} msg --json event-stream | from json
    }

    job background
    job send
    job recv

    match $event {

    }

  '';
in
{
  programs.niri.settings.spawn-at-startup = [
    {
      command = [
        (lib.getExe niri-event-stream-handler)
      ];
    }
  ];
  home.packages = [ niri-event-stream-handler ];
}
