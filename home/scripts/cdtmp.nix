{
  config,
  lib,
  pkgs,
  ...
}:
let
  script =
    pkgs.writers.writeFishBin "cdtmp" { }
      # fish
      '''';
in
{

}
