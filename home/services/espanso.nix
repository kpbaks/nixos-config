{ config, pkgs, ... }:
let
  prefix-char = ":";
  match = trigger: replace: {
    trigger = prefix-char + trigger;
    replace = replace;
  };
in
{

  # TODO: figure out how to install packages from espansohub
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;

    configs.vscode = {
      filter_title = "Visual Studio Code$";
      backend = "Clipboard";
    };

    configs.default = {
      backend = "Auto";
      auto_restart = true;
      show_icon = true;
      show_notifications = true;
      preserve_clipboard = true;
      undo_backspace = true;
      toggle_key = "ALT";
      search_shortcut = "ALT+SHIFT+ENTER";
      # search_shortcut = "ALT+SPACE"; # default
    };
    matches.base.matches = with config.personal; [
      (match "tuta" tutamail)
      (match "gmail" gmail)
      (match "email" email)
      # (espanso-match "aumail" aumail)
      (match "tf" telephone-number)
      (match "phone" telephone-number)
      (match "name" name)
      (match "fname" full-name)
      # (espanso-match "addr" "Helsingforsgade 19 st, 4")
      (match "city" "8230 Åbyhøj")
      (match "addr" "Søren Frichs Vej 55G, 2.12")
      (match "rg" ''
        Regards
        ${full-name}
      '')
      {
        trigger = "~o";
        replace = "ø";
      }
      {
        trigger = "~e";
        replace = "æ";
      }
      {
        trigger = "~a";
        replace = "å";
      }
      {
        trigger = "~O";
        replace = "Ø";
      }
      {
        trigger = "~E";
        replace = "Æ";
      }
      {
        trigger = "~A";
        replace = "Å";

      }
    ];
  };
}
