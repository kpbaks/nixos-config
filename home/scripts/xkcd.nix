{ pkgs, ... }:

let
  script =
    pkgs.writers.writeFishBin "xkcd" { } # fish

      ''
        if not isatty stdin
          # has to be run from a terminal
          return 2
        end
        set -l url https://xkcd.com # latest comic
        set -l imgs (${pkgs.curl}/bin/curl --silent $url -o - | ${pkgs.htmlq}/bin/htmlq img --attribute src)
        set -l comic_img
        for img in $imgs
          # //imgs.xkcd.com/comics/einstein.png
          if string match --quiet "//imgs.xkcd.com/comics/*.png" -- $img
            set comic_img $img
            break
          end
        end


        set comic_img https:$comic_img

        # TODO: print the title of the comic, and a link to it
        ${pkgs.curl}/bin/curl --silent $comic_img -o - | ${pkgs.timg}/bin/timg - --center
      '';
in
{
  home.packages = [ script ];
}
