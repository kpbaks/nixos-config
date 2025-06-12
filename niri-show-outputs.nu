#! /nix/store/ywp33ksgp2v32g0dwril2ds1rlri1kp8-nushell-0.104.0/bin/nu --no-config-file
# TODO: handle case where `niri` is not the active compositor
let outputs = (niri msg --json outputs | from json)

let body = $outputs | items { |name, output|
  let x: int = ($output | get logical.x)
  let y: int = ($output | get logical.y)
  let width: int = ($output | get logical.width / 10)
  let height: int = ($output | get logical.height / 10)

  let rect = $"<rect x='($x)' y='($y)' width='($width)' height='($height)' fill='#ff0000' stroke='#ffffff' stroke-width='6px' />"

 $rect

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

 } | str join "\n"

const HEADER: string = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">'
const FOOTER: string = "</svg>"


print $body
# return

let svg_document = [$HEADER $body $FOOTER] | str join "\n"

$svg_document | /nix/store/119y38i56azh5iflcwwwkws52h40y60d-bat-0.25.0/bin/bat -l svg

$svg_document | /nix/store/073hfl7g0rpr6m3i4xslcymhyj9cwslq-resvg-0.45.1/bin/resvg --resources-dir . - -c | /nix/store/ccqvkclhmp0dlx00fyfg7wjzvhsdnm9x-timg-1.6.2/bin/timg --center -

# let svg_file = (mktemp --suffix svg)
# $svg_document | save $svg_file

# resvg

# timg

# rm $svg_file


# end | resvg --resources-dir . - $png_path

# timg --center $png_path
