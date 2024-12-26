{ pkgs, ... }:
{
  home.packages = with pkgs; [
    forgejo
    forgejo-actions-runner
    forgejo-cli
  ];
}
