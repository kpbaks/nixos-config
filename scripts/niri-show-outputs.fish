#!/usr/bin/env -S fish --no-config

# TODO: use nix somehow to make external dependencies available

# !/usr/bin/env nix-shell
# ! nix-shell -i fish -p resvg jaq timg

set -l png_path (mktemp --suffix .png)
set -l scale 0.2
set -l font_size 14
set -l fill 'rgba(255, 0, 0, 0.5)'
set -l stroke 'rgba(255, 0, 0, 1)'
set -l shared_text_properties "font-family='DejaVu Sans' fill='white'"
# set -l shared_text_properties "text-anchor='middle' font-size='$font_size' fill='black'"
set -l x_offset 100
set -l y_offset 100
set -l label_offset 10

set -l fill_alpha 0.5
set -l stroke_alpha 1.0

set -l fills "rgba(255, 0, 0, $fill_alpha)" "rgba(0, 255, 0, $fill_alpha)" "rgba(0, 0, 255, $fill_alpha)"
set -l strokes "rgba(255, 0, 0, $stroke_alpha)" "rgba(0, 255, 0, $stroke_alpha)" "rgba(0, 0, 255, $stroke_alpha)"

set -l xmin $x_offset
set -l xmax $xmin
set -l ymin $y_offset
set -l ymax $ymin

begin
    echo '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">'
    set -l jq_expr '.[] | [.name, .logical.x, .logical.y, .logical.width, .logical.height] | @csv'
    set -l i 1
    niri msg --json outputs | jaq -r $jq_expr | while read -d , name x y width height
        set -l fill $fills[$i]
        set -l stroke $strokes[$i]
        set i (math "$i + 1 % $(count $fills)")
        test $i -eq 0; and set i 1 # arrays start at 1 in fish

        set name (string sub --start 2 --end -1 -- $name) # remove quotes
        set x_scaled (math "$x * $scale + $x_offset")
        set y_scaled (math "$y * $scale + $y_offset")
        set width_scaled (math "$width * $scale")
        set height_scaled (math "$height * $scale")

        # echo "x_scaled: $x_scaled" >&2
        # echo "y_scaled: $y_scaled" >&2
        # echo "width_scaled: $width_scaled" >&2
        # echo "height_scaled: $height_scaled" >&2

        if test (math $x_scaled + $width_scaled) -gt $xmax
            set xmax (math $x_scaled + $width_scaled)
        end
        if test (math $y_scaled + $height_scaled) -gt $ymax
            set ymax (math $y_scaled + $height_scaled)
        end

        # Add rectangle
        echo "<rect x='$x_scaled' y='$y_scaled' width='$width_scaled' height='$height_scaled' fill='$fill' stroke='$stroke' stroke-width='6px' />"

        # Add text for width and height
        # top center
        set -l width_center (math $x_scaled + $width_scaled / 2)
        set -l height_center (math $y_scaled + $height_scaled / 2)
        echo "<text x='$width_center' y='$(math $y_scaled - $label_offset)' text-anchor='middle' font-size='$font_size' $shared_text_properties>$width px </text>"

        # bottom center
        printf "<text x='%d' y='%d' text-anchor='middle' font-size='$font_size' $shared_text_properties> %spx</text>\n" $width_center (math "$y_scaled + $height_scaled + $label_offset * 2") $width
        # right center
        printf "<text x='%d' y='%d' text-anchor='start' font-size='$font_size' $shared_text_properties> %spx</text>\n" (math $x_scaled + $width_scaled + $label_offset) $height_center $height
        # left center
        printf "<text x='%d' y='%d' text-anchor='end' font-size='$font_size' $shared_text_properties> %spx</text>\n" (math $x_scaled - $label_offset) $height_center $height

        # Add text for display name in the center of the rectangle
        printf "<text x='%d' y='%d' font-size='20' text-anchor='middle' $shared_text_properties> %s</text>\n" (math $x_scaled + $width_scaled / 2) (math $y_scaled + $height_scaled / 2) $name

    end

    # TODO: move above in xml to have lower z index
    # draw dashed bbox
    # FIXME: solve in a more elegant way than this subtraction
    set xmax (math "$xmax - $x_offset")
    set ymax (math "$ymax - $y_offset")
    echo "<rect x='$xmin' y='$xmin' width='$xmax' height='$ymax' stroke-dasharray='5,5' stroke='white' stroke-width='2px' fill='none' />"
    printf "<text x='%s' y='%s' text-anchor='middle' font-size='$font_size' $shared_text_properties> %spx,%spx</text>\n" (math "$xmin - $x_offset / 4") (math "$ymin - $y_offset / 4") 0 0
    printf "<text x='%s' y='%s' text-anchor='middle' font-size='$font_size' $shared_text_properties> %spx,%spx</text>\n" (math "$xmax + $x_offset * 1.25") (math "$ymax + $y_offset * 1.25") (math "$xmax / $scale") (math "$ymax / $scale")


    echo '</svg>'

end | resvg --resources-dir . - $png_path

timg --center $png_path
# timg $png_path

# echo "xmax: $xmax, ymax: $ymax"

command rm $png_path
