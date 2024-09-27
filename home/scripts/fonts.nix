{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "fonts" { }
      # nu
      ''
        ^${pkgs.fontconfig}/bin/fc-list
        | parse "{file}: {name}:style={style}"
        | move file --after style
        | sort-by --ignore-case  name
      '';
in
{
  home.packages = [ script ];
}
