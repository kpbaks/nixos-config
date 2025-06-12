{
  config,
  lib,
  pkgs,
  ...
}:
let
  # niri = lib.getExe config.programs.niri.package;
  niri = "niri";
  script =
    pkgs.writers.writeFishBin "niri-notify-when-keyboard-layout-changes" { }
      # fish
      ''
        set -l title "niri"

        ${niri} msg --json event-stream \
        | ${pkgs.jaq}/bin/jaq "try .KeyboardLayoutSwitched.idx" \
        | while read idx
          # set -l keyboard_layouts (${niri} msg --json keyboard-layouts | ${pkgs.jaq}/bin/jaq --raw-output ".names")
          # set idx (math "$idx + 1") # fish uses 1 based indexing
          # set -l layout $keyboard_layouts[$idx]
          set -l keyboard_layout (${niri} msg --json keyboard-layouts | ${pkgs.jaq}/bin/jaq --raw-output ".names[.current_idx]")

          set -l flag
          switch $keyboard_layout
            case "Danish"
              set flag 🇩🇰
            case "English (US)"
              set flag 🇺🇸
            case '*'
          end
          set -l body "Changed keyboard layout to <b>$keyboard_layout</b> $flag"

          # TODO: use --icon for flag?
          ${pkgs.libnotify}/bin/notify-send --expire-time 1000 --transient $title $body
        end
      '';
in
{

  programs.niri.settings.spawn-at-startup = [
    {
      command = [ "${lib.getExe script}" ];
    }
  ];
}
