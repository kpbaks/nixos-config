{
  config,
  lib,
  pkgs,
  ...
}:

let
  git-browse = pkgs.writeShellApplication {
    name = "git-browse";
    runtimeInputs = [
      config.programs.git.package
      config.programs.fzf.package
      pkgs.xdg-utils
    ];
    text = ''
      # .git/refs/remotes/*
      # remotes=
      git remote

      # more than 1 remote use fzf to pick
    '';
  };
in
{
  home.packages = [ git-browse ];
}
