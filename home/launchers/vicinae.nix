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

  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      vicinae = "${config.services.vicinae.package}/bin/vicinae";
      open-deeplink = deeplink: spawn vicinae "vicinae://${deeplink}";
    in
    {
      "Mod+Slash" = {
        action = open-deeplink "toggle";
        hotkey-overlay.title = "Toggle Application Launcher (vicinae)";
        repeat = false;
      };
      "Mod+V" = {
        action = open-deeplink "extensions/vicinae/clipboard/history";
        hotkey-overlay.title = "Open Clipboard History Menu";
        repeat = false;
      };
      "Mod+Period" = {
        action = open-deeplink "extensions/vicinae/vicinae/search-emojis";
        hotkey-overlay.title = "Open Emoji Picker";
        repeat = false;
      };
      "Mod+B" = {
        action = open-deeplink "extensions/Gelei/bluetooth/devices";
        hotkey-overlay.title = "Open Bluetooth device list";
        repeat = false;
      };
      "Mod+Shift+W" = {
        # "Mod+W" is used for wallpaper selector
        action = open-deeplink "extensions/dagimg-dot/wifi-commander/manage-saved-networks";
        hotkey-overlay.title = "Manage Saved Wifi Networks";
        repeat = false;
      };
      # "Alt+Tab" = {
      #   action = open-deeplink "extensions/vicinae/wm/switch-windows";
      #   hotkey-overlay.title = "switch windows";
      #   repeat = false;
      # };
    };
}
