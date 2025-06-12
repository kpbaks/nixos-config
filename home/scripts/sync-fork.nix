{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "sync-fork" { }
      # nu
      '''';
in
{
  home.packages = [ script ];
}
