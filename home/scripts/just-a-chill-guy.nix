{ pkgs, ... }:

let
  script =
    pkgs.writers.writeNuBin "just-a-chill-guy" { }
      # nu
      ''
        let url = "https://i.kym-cdn.com/photos/images/newsfeed/002/901/902/95c.png"
        http get $url | ${pkgs.timg}/bin/timg --center -
      '';
in
{
  home.packages = [ script ];
}
