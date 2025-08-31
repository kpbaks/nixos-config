{
  config,
  osConfig,
  pkgs,
  ...
}:
{

  services.udiskie = {
    enable = true;
    # TODO: Have home-manager assert that `osConfig.services.udisks2.enable` is true, if you use NixOS
    # https://github.com/nix-community/home-manager/blob/cc2fa2331aebf9661d22bb507d362b39852ac73f/modules/services/udiskie.nix#L36-L45
    # enable = osConfig.services.udisks2.enable;
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

  systemd.user.services.udiskie = {
    Unit.ConditionEnvironment = [
      "XDG_CURRENT_DESKTOP=niri"
    ];
  };
}
