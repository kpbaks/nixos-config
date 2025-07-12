{
  config,
  lib,
  pkgs,
  ...
}:
let
  default = {
    terminal = false;
    type = "System";
    categories = [ "System" ];
  };
in
{

  #   name = "niri - Open screenshots directory";
  #   exec = lib.getExe (
  #     pkgs.writeShellScriptBin "niri-open-screenshots-dir" ''${pkgs.libnotify}/bin/xdg-open $(dirname ${config.programs.niri.settings.screenshot-path})''
  #   );
  #   terminal = false;
  #   type = "Application";
  #   categories = [ "System" ];
  # };

  xdg.desktopEntries = {
    poweroff = {
      name = "Poweroff";
      exec = "${pkgs.systemd}/bin/systemctl poweroff";
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
    reboot = {
      name = "Reboot";
      exec = "${pkgs.systemd}/bin/systemctl reboot";
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
    # Use `loginctl list-sessions`
    # logout = { };
    sleep = {

      name = "Suspend";
      exec = "${pkgs.systemd}/bin/systemctl suspend";
      terminal = false;
      type = "Application";
      categories = [ "System" ];

    };
    hybrid-sleep = {
      name = "Hybrid sleep";
      exec = "${pkgs.systemd}/bin/systemctl hybrid-sleep";
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
    hibernate = {
      name = "Hibernate";
      exec = "${pkgs.systemd}/bin/systemctl hibernate";
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
  };

  # xdg.desktopEntries.${name} = {
  #   name = "niri - Pick color";
  #   exec = lib.getExe script;
  #   terminal = false;
  #   type = "Application";
  #   categories = [ "System" ];
  # };

}
