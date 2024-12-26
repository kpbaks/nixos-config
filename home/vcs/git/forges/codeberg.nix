{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # fjo
    codeberg-cli
    # codeberg-pages
  ];
}
