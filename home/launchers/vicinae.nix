{ config, inputs, ... }:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;
    settings = {
      font.size = 12;
      theme.name = "vicinae-dark";
    };
  };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Slash" = {
      action = spawn "${config.services.vicinae.package}/bin/vicinae" "toggle";
      hotkey-overlay.title = "Toggle Application Launcher (vicinae)";
      repeat = false;
    };
  };
}
