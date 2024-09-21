{ config, pkgs, ... }:
{

  services.espanso =
    let
      espanso-prefix-char = ":";
      espanso-match = trigger: replace: {
        trigger = espanso-prefix-char + trigger;
        replace = replace;
      };
    in
    {
      enable = true;
      package = pkgs.espanso-wayland;

      configs.default = {
        backend = "Auto";
        auto_restart = true;
        show_icon = true;
        show_notifications = true;
        preserve_clipboard = true;
        undo_backspace = true;
        toggle_key = "ALT";
        # search_shortcut = "ALT+SHIFT+ENTER";
        search_shortcut = "ALT+SPACE"; # default
      };
      matches.base.matches = with config.personal; [
        (espanso-match "tuta" tutamail)
        (espanso-match "gmail" gmail)
        (espanso-match "email" email)
        # (espanso-match "aumail" aumail)
        (espanso-match "tf" telephone-number)
        (espanso-match "phone" telephone-number)
        (espanso-match "name" name)
        (espanso-match "fname" full-name)
        # (espanso-match "addr" "Helsingforsgade 19 st, 4")
        (espanso-match "city" "8230 Åbyhøj")
        (espanso-match "addr" "Søren Frichs Vej 55G, 2.12")
        (espanso-match "rg" ''
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
      # map (it: espanso-match )[
      #   [
      #     "tuta"
      #     tutamail
      #   ]
      #   [
      #     "gmail"
      #     gmail
      #   ]
      #   [
      #     "email"
      #     email
      #   ]
      #   # (espanso-match "aumail" aumail)
      #   [
      #     "tf"
      #     telephone-number
      #   ]
      #   [
      #     "phone"
      #     telephone-number
      #   ]
      #   [
      #     "name"
      #     name
      #   ]
      #   [
      #     "fname"
      #     full-name
      #   ]
      #   # (espanso-match "addr" "Helsingforsgade 19 st, 4")
      #   [
      #     "addr"
      #     "Søren Frichs Vej 55G, 2.12"
      #   ]
      #   [
      #     "rg"
      #     ''
      #       Regards
      #       ${full-name}
      #     ''
      #   ]
      # ];
    };
}
