{ pkgs, ... }:
{
  home.packages = with pkgs; [ contour ];
}
