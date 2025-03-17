# TODO: get app indicator to work
{ config, pkgs, ... }:
let
  prefix-char = ":";
  match = trigger: replace: { inherit trigger replace; };
  match-with-prefix = trigger: replace: match (prefix-char + trigger) replace;
in
{

  # TODO: figure out how to install packages from espansohub
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;

    configs = {
      # show_notifications = true;
      # vscode = {
      #   filter_title = "Visual Studio Code$";
      #   backend = "Clipboard";
      # };

      # default = {
      #   backend = "Auto";
      #   auto_restart = true;
      #   show_icon = true;
      #   show_notifications = true;
      #   preserve_clipboard = true;
      #   undo_backspace = true;
      #   toggle_key = "ALT";
      #   search_shortcut = "ALT+SHIFT+ENTER";
      #   # search_shortcut = "ALT+SPACE"; # default
      # };
    };
    matches.base.matches = with config.personal; [
      (match-with-prefix "tuta" tutamail)
      (match-with-prefix "gmail" gmail)
      (match-with-prefix "email" email)
      (match-with-prefix "workmail" "kristoffer.plagborgbak.soerensen@beumer.com")
      # (espanso-match "aumail" aumail)
      (match-with-prefix "tf" telephone-number)
      (match-with-prefix "phone" telephone-number)
      (match-with-prefix "name" name)
      (match-with-prefix "fname" full-name)
      # (espanso-match "addr" "Helsingforsgade 19 st, 4")
      (match-with-prefix "city" "8230 Åbyhøj")
      (match-with-prefix "addr" "Søren Frichs Vej 55G, 2.12")
      (match-with-prefix "rg" ''
        Regards
        ${full-name}
      '')
      (match "~o" "ø")
      (match "~e" "æ")
      (match "~a" "å")
      (match "~O" "Ø")
      (match "~E" "Æ")
      (match "~A" "Å")
    ];
  };
}
