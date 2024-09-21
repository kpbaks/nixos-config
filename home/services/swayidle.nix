{ pkgs, ... }:
{

  services.swayidle = {
    enable = false;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
    ];
    timeouts =
      let
        sec = x: x; # expected unit is seconds
      in
      [
        {
          timeout = sec 180;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
  };
}
