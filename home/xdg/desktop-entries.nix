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
  # xdg.desktopEntries = {
  #   poweroff = { };
  #   reboot = { };
  #   logout = { };
  #   sleep = { };
  #   hibernate = { };
  # };

  # xdg.desktopEntries.${name} = {
  #   name = "niri - Pick color";
  #   exec = lib.getExe script;
  #   terminal = false;
  #   type = "Application";
  #   categories = [ "System" ];
  # };

}
