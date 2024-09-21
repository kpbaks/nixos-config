{ config, pkgs, ... }:
{

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
    # https://github.com/coldfix/udiskie/blob/master/doc/udiskie.8.txt#configuration
    settings = {
      program_options = {
        file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
        terminal = config.default-application.terminal;
      };
    };
  };

}
