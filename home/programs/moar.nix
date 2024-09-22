{ pkgs, ... }:
{
  home.packages = with pkgs; [ moar ];

  home.sessionVariables = {
    PAGER = "${pkgs.moar}/bin/moar";
    MOAR = builtins.concatStringsSep " " [
      "-statusbar=bold"
      "-no-linenumbers"
      "-quit-if-one-screen"
      "-no-clear-on-exit"
      "-wrap"
      "-colors 16M" # truecolor
    ];
  };
}
