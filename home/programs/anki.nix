{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    # anki-sync-server
    # ankisyncd
  ];
}
