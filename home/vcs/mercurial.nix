{ pkgs, ... }:
{
  home.packages = with pkgs; [ mercurial ];
}
