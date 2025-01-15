{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dependabot-cli
  ];
}
