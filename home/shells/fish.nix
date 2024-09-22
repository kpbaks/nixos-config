{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ fish ];
}
