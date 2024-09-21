{ pkgs, ... }:
{

  # FIXME: figure out how to store icons files
  programs.wlogout = {
    enable = false;
    # TODO: use catppuccin
    # https://github.com/ArtsyMacaw/wlogout/blob/master/style.css
    style = # css
      ''
        * {
        	background-image: none;
        	box-shadow: none;
        }

        window {
        	background-color: rgba(12, 12, 12, 0.9);
        }

        button {
          color: #AAB2BF;
        }

        .shutdown {
          background-color: #ff0000;
        }
      '';
    # TODO: give each a different catppuccin color
    # see `man 5 wlogout`
    layout =
      let
        circular = false;
      in
      [
        {
          label = "shutdown"; # css label
          action = "${pkgs.systemd}/bin/systemctl --no-block poweroff";
          text = "Shutdown";
          keybind = "s";
          inherit circular;
        }
        {
          label = "lock";
          action = "${pkgs.systemd}/bin/loginctl lock-session";
          text = "Lock";
          keybind = "l";
          inherit circular;
        }
        {
          label = "hibernate";
          action = "${pkgs.systemd}/bin/systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
          inherit circular;
        }
        {
          label = "logout";
          action = "${pkgs.systemd}/bin/loginctl terminate-user $USER";
          text = "Logout";
          keybind = "e";
          inherit circular;
        }
        {
          label = "suspend";
          action = "${pkgs.systemd}/bin/systemctl suspend";
          text = "Suspend";
          keybind = "u";
          inherit circular;
        }
        {
          label = "reboot";
          action = "${pkgs.systemd}/bin/systemctl reboot";
          text = "Reboot";
          keybind = "r";
          inherit circular;
        }
      ];
  };
}
