{ pkgs, ... }:
{
  home.packages = with pkgs; [
    odin
    ols
  ];
}
