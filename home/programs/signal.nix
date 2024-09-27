{ pkgs, ... }:
{
  home.packages = with pkgs; [
    signal-desktop
    signal-cli
    # signaldctl
    # signald
  ];
}
