{ pkgs, ... }:
{
  home.packages = with pkgs; [ exercism ];

  # TODO: use a activation script for `exercism completion {powershell,fish,bash,zsh}`
}
