{ lib, pkgs, ... }:
{
  # https://yalter.github.io/niri/Configuration%3A-Miscellaneous.html#xwayland-satellite
  home.packages = [ pkgs.xwayland-satellite ];
  programs.niri.settings.xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
}
