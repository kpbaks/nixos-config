{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qownnotes
    qc
  ];
}
