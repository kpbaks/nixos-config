{ ... }:
{
  programs.ripgrep = {
    enable = true;
    arguments =
      let
        # https://github.com/BurntSushi/ripgrep/blob/master/FAQ.md#how-do-i-configure-ripgreps-colors
        hex2ripgrep-color =
          hex:
          let
            ss = builtins.substring;
            hex' = ss 1 6 hex; # strip leading `#` e.g. "#aabbee" -> "aabbee"
            # extract each channel into a 2 char string
            r = ss 0 2 hex';
            g = ss 2 2 hex';
            b = ss 4 2 hex';
          in
          builtins.concatStringsSep "," (
            map (channel: "0x${channel}") [
              r
              g
              b
            ]
          );
      in
      [
        # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
        "--max-columns=150"
        "--max-columns-preview"
        # Add my 'web' type.
        "--type-add"
        "web:*.{html,css,js}*"
        # Search hidden files/directories by default
        "--hidden"
        # "--hyperlink-format=default"
        "--hyperlink-format=kitty"
        # Set the colors.
        "--colors=line:fg:${hex2ripgrep-color palette.catppuccin.teal.hex}"
        "--colors=column:fg:${hex2ripgrep-color palette.catppuccin.maroon.hex}"
        "--colors=path:fg:${hex2ripgrep-color palette.catppuccin.sky.hex}"
        "--colors=match:none"
        "--colors=match:bg:${hex2ripgrep-color palette.catppuccin.peach.hex}"
        "--colors=match:fg:${hex2ripgrep-color palette.catppuccin.crust.hex}"
        "--colors=match:style:bold"

        "--smart-case"
        "--pcre2-unicode"
      ];
  };
}
