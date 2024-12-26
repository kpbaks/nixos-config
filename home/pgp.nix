{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnupg
    gpg-tui
  ];
}
