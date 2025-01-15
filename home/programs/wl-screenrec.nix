{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  script =
    pkgs.writers.writeNuBin "wl-screenrec-record" { }
      # nu
      ''
        # TODO: detect best codec, in case discrete gpu is available
        let codec = "av1"

        ${getExe pkgs.wl-screenrec} --codec $codec --geometry ${getExe pkgs.slurp}
        # TODO: find video dir using xdg
        # TODO: report errors with notify-send

      '';
in
{
  home.packages = with pkgs; [
    wl-screenrec
    wl-gammarelay-rs
    wl-gammarelay-applet
    wl-crosshair
    slurp
    script
  ];

  # TODO: create a script and xdg .desktop entry for a script to select a region
  # and start a screen recording
  xdg.desktopEntries.wl-screenrec = {
    name = "wl-screenrec";
    # genericName = "Web Browser";
    exec = "${getExe script}";
    terminal = true;
    categories = [
      "Application"
    ];
    # TODO: use image/* and video/*
    # mimeType = [
    #   "text/html"
    #   "text/xml"
    # ];
  };
}
