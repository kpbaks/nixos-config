{
pkgs,
  ...
}:
let nurl-it = pkgs.writers.writeFishBin "nurl-it" {} # fish
''
echo foo
'';
in

{
  programs.plasma.configFile."klipperrc" = {
    General = {
      MaxClipItems = 1000;
      UrlGrabberEnabled = true;
      IgnoreImages = false;
    };

    Actions = {
      ReplayActionInHistory = true;
    }
  };
}
