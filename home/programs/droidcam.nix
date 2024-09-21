{ pkgs, ... }:
{
  home.packages = with pkgs; [
    droidcam
    # droidmote
  ];

  systemd.user.services.droidcam = {
    Unit = {
      Description = "Start the droidcam client and connect to your phone over IP LAN";
      BindsTo = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      # TODO: setup more robustly, by having the ip addr be discovered
      ExecStart = "${pkgs.droidcam}/bin/droidcam-cli 192.168.0.134 4747 -a -v";
      StandardOutput = "journal";
    };
  };
}
