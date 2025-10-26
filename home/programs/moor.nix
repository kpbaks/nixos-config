{ pkgs, ... }:
{
  home.packages = with pkgs; [ moor ];

  home.sessionVariables = {
    PAGER = "${pkgs.moor}/bin/moor";
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
