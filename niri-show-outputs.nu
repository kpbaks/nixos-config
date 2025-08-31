#! /usr/bin/env nu --no-config-file

let outputs = try {
  ^niri msg --json outputs | from json
} catch {
  # TODO: handle case where `niri` is not the active compositor

}

let output_data: table<name: string, x: int, y: int, width: float, height: float> = $outputs | items { |name, output|
  let x: int = ($output | get logical.x)
  let y: int = ($output | get logical.y)
  let width: int = ($output | get logical.width | do { $in / 1 } )
  let height: int = ($output | get logical.height | do { $in / 1 } )

  [[name, x, y, width, height]; [$name, $x, $y, $width, $height]]
}
| flatten

let x_offset: int = [0 ...$output_data.x] | math min | do { -1 * $in }
let y_offset: int = [0 ...$output_data.y] | math min | do { -1 * $in }


# FIXME: handle > 3 monitors
let fill_colors: list<string> = ["#ff0000" "#00ff00" "#0000ff"]

const font = "JetBrainsMono Nerd Font Mono"


let svg_body = $output_data
| update x { $in + $x_offset }
| update y { $in + $y_offset }
| zip $fill_colors
| each {|pair|
  let output = $pair.0
  let fill_color = $pair.1
  let rect = $"<rect x='($output.x)' y='($output.y)' width='($output.width)' height='($output.height)' fill='($fill_color)' stroke='#000000' stroke-width='6px' />"

  let width_center = $output.x + $output.width / 2
  let height_center = $output.y + $output.height / 2

  let width_text = $"<text x='($width_center)' y='($height_center)' text-anchor='middle' font-family='($font)' font-size='20'>($output.width) px</text>"

   let name_text = $"<text x='($width_center)' y='($height_center)' text-anchor='middle' dominant-baseline='middle' font-family='($font)' font-size='20' fill='black'>($output.name)</text>"

    # <!-- Define the text centered within the rectangle -->
  # <text x="150" y="100" text-anchor="middle" dominant-baseline="middle" font-family="Arial" font-size="20" fill="black">
  #   Centered Text
  # </text>


  [$rect $width_text $name_text]

# #  # Add text for width and height
# #  # top center
# #  set -l width_center (math $x_scaled + $width_scaled / 2)
# #  set -l height_center (math $y_scaled + $height_scaled / 2)
# #  echo "<text x='$width_center' y='$(math $y_scaled - $label_offset)' text-anchor='middle' font-size='$font_size' $shared_text_properties>$width px </text>"

# #  # bottom center
# #  printf "<text x='%d' y='%d' text-anchor='middle' font-size='$font_size' $shared_text_properties> %spx</text>\n" $width_center (math "$y_scaled + $height_scaled + $label_offset * 2") $width
# #  # right center
# #  printf "<text x='%d' y='%d' text-anchor='start' font-size='$font_size' $shared_text_properties> %spx</text>\n" (math $x_scaled + $width_scaled + $label_offset) $height_center $height
# #  # left center
# #  printf "<text x='%d' y='%d' text-anchor='end' font-size='$font_size' $shared_text_properties> %spx</text>\n" (math $x_scaled - $label_offset) $height_center $height

# #  # Add text for display name in the center of the rectangle
# #  printf "<text x='%d' y='%d' font-size='20' text-anchor='middle' $shared_text_properties> %s (scale: %s)</text>\n" (math $x_scaled + $width_scaled / 2) (math $y_scaled + $height_scaled / 2) $name $scale


}
| flatten
| each { $"    ($in)" }
| str join "\n"

# TODO: add other attributes
const HEADER: string = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">'
const FOOTER: string = "</svg>"


let svg_document = [$HEADER $svg_body $FOOTER] | str join "\n"

$svg_document | save -f niri-outputs.svg

print ($svg_document | bat -l svg --color always --plain)

$svg_document | resvg --resources-dir . - -c | timg --center -
