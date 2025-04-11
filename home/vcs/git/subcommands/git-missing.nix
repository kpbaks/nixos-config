{ config, pkgs, ... }:
let
  git = "${config.programs.git.package}/bin/git";
  git-missing =
    pkgs.writers.writeFishBin "git-missing" { }
      # fish
      '''';
in

{
  home.packages = [ git-missing ];

}
