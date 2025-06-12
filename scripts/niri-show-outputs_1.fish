#!/usr/bin/env nix-shell
#! nix-shell -i fish -p resvg jaq

begin
    echo '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">'
    set -l jq_expr '.[] | [.name .logical.x .logical.y .logical.width .logical.height] | @csv'
    niri msg outputs | jaq -r $jq_expr | while read -d , name x y width height
        echo "<rect x='$x' y='$y' width='$width' height='$height' fill='red' stroke='black' />"
    end
    echo ' </svg >'
end
