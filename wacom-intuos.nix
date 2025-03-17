# Configuration for my Wacom Intuos drawing tablet
{ pkgs, ... }:
{
  hardware.opentabletdriver.enable = true;
  # environment.systemPackages = with pkgs; [ libwacom ];
  boot.kernelModules = [ "wacom" ];
}
