{
  config,
  lib,
  pkgs,
  ...
}:
let
  niri = "${config.programs.niri.package}/bin/niri";
  catppuccin-colors = lib.pipe config.flavor [
    (builtins.mapAttrs (name: v: ''const ${name}: string = "${v.hex}"''))
    builtins.attrValues
    lib.concatLines
  ];
  script = pkgs.writers.writeNuBin "niri.show-outputs" { } (
    catppuccin-colors
    +
      # nu
      ''
          let outputs = (${niri} msg --json outputs | from json)

          mut buf = ""

          let body = $outputs | items { |name, output|
           let x = ($output | get logical.x)
           let y = ($output | get logical.y)
           let width = ($output | get logical.width)
           let height = ($output | get logical.height)

           let rect = $"<rect x='($x)' y='($y)' width='($width)' height='($height)' fill='#ff0000' stroke='#ffffff' stroke-width='6px' />"

          # $rect

          #  $buf += $rect



         # # Add rectangle
         #  echo "<rect x='$x_scaled' y='$y_scaled' width='$width_scaled' height='$height_scaled' fill='$fill' stroke='$stroke' stroke-width='6px' />"

         #  # Add text for width and height
         #  # top center
         #  set -l width_center (math $x_scaled + $width_scaled / 2)
         #  set -l height_center (math $y_scaled + $height_scaled / 2)
         #  echo "<text x='$width_center' y='$(math $y_scaled - $label_offset)' text-anchor='middle' font-size='$font_size' $shared_text_properties>$width px </text>"

         #  # bottom center
         #  printf "<text x='%d' y='%d' text-anchor='middle' font-size='$font_size' $shared_text_properties> %spx</text>\n" $width_center (math "$y_scaled + $height_scaled + $label_offset * 2") $width
         #  # right center
         #  printf "<text x='%d' y='%d' text-anchor='start' font-size='$font_size' $shared_text_properties> %spx</text>\n" (math $x_scaled + $width_scaled + $label_offset) $height_center $height
         #  # left center
         #  printf "<text x='%d' y='%d' text-anchor='end' font-size='$font_size' $shared_text_properties> %spx</text>\n" (math $x_scaled - $label_offset) $height_center $height

         #  # Add text for display name in the center of the rectangle
         #  printf "<text x='%d' y='%d' font-size='20' text-anchor='middle' $shared_text_properties> %s (scale: %s)</text>\n" (math $x_scaled + $width_scaled / 2) (math $y_scaled + $height_scaled / 2) $name $scale

          }
          | str join "\n"

        const HEADER: string = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">'
        const FOOTER: string = "</svg>"
         let svg_data = $HEADER + $body + $FOOTER

        $svg_data | ${pkgs.bat}/bin/bat -l svg

         $svg_data | ${pkgs.resvg}/bin/resvg --resources-dir . - -c | ${pkgs.timg}/bin/timg --center -

         # let svg_file = (mktemp --suffix svg)
         # $svg_data | save $svg_file

         # resvg

         # timg

         # rm $svg_file

               
         # end | resvg --resources-dir . - $png_path

         # timg --center $png_path
      ''
  );
in
{
  home.packages = [
    script
  ];
}
