{ pkgs, ... }:

pkgs.writers.writeNuBin "systemd-failed-units" { }
  # nu
  ''
    def main [subcommand: string] {
      let failed_units = {
        user: ${pkgs.systemd}/bin/systemctl --user list-units --failed --output=json | from json | get unit
        system: ${pkgs.systemd}/bin/systemctl list-units --failed --output=json | from json | get unit
      }

      let icon = "yast-bootloader" # Most appropriate one I could find (lør 17 aug 20:48:35 CEST 2024)
    }



  ''

# xdg.desktopEntries.systemd-failed-units = {
#   name = "Systemd - List Failed Units";
#   # exec = "emacsclient -- %u";
#   exec = pkgs.lib.getExe scripts.systemd-failed-units;
#   # TODO: use this icon
#   # https://raw.githubusercontent.com/systemd/systemd/main/docs/assets/systemd-logo.svg
#   terminal = true;
#   type = "Application";
#   categories = [ "System" ];
#   actions = {
#     restart = {
#       exec = "${pkgs.lib.getExe scripts.systemd-failed-units} restart";
#     };
#   };
# };

# scripts.systemd-failed-units =
#   pkgs.writers.writeFishBin "systemd-failed-units" { } # fish
#     ''
#       set -l jq_expr ".[].unit"
#       set -l user_failed_units (${pkgs.systemd}/bin/systemctl --user list-units --failed --output=json | ${pkgs.jaq}/bin/jaq -r $jq_expr)
#       set -l system_failed_units (${pkgs.systemd}/bin/systemctl list-units --failed --output=json | ${pkgs.jaq}/bin/jaq -r $jq_expr)
#       set -l failed_units $system_failed_units $user_failed_units

#       set -l subcommand tui
#       if test (count $argv) -gt 0
#         set subcommand $argv[1]
#       end

#       set -l icon yast-bootloader # Most appropriate one I could find (lør 17 aug 20:48:35 CEST 2024)

#       if test (count $failed_units) -eq 0
#         set -l msg "No failed units ☺️"
#         if not isatty stdout
#         # TODO: only notify-send if not running in terminal
#           ${pkgs.libnotify}/bin/notify-send --icon $icon systemd $msg
#           else
#             echo $msg >&2
#           end

#         return
#       end

#       function run
#         if isatty stderr
#           echo $argv | ${pkgs.fish}/bin/fish_indent --ansi >&2
#         end
#         eval $argv
#       end

#       switch $subcommand
#         case restart
#           if test (count $user_failed_units) -gt 0
#             run ${pkgs.systemd}/bin/systemctl --user restart $user_failed_units
#             if not isatty stdout
#               ${pkgs.libnotify}/bin/notify-send --icon $icon systemd "Restarted the following <b>user</b> units:\n$(printf \"- %s\n\" $user_failed_units)"
#             end
#           end
#           if test (count $system_failed_units) -gt 0
#             run ${pkgs.systemd}/bin/systemctl restart $system_failed_units
#             if not isatty stdout
#               ${pkgs.libnotify}/bin/notify-send --icon $icon systemd "Restarted the following <b>system</b> units:\n$(printf \"- %s\n\" $system_failed_units)"
#             end
#           end
#         case tui
#           set -l expr ${pkgs.systemctl-tui}/bin/systemctl-tui --limit-units $failed_units
#           set -q KITTY_PID; or set --prepend expr ${terminal}
#           eval $expr
#         case '*'
#       end
#     '';
