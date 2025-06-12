{
  config,
  lib,
  pkgs,
  ...
}:
let
  gitCmd = lib.getExe config.programs.git.package;
  script =
    pkgs.writers.writeFishBin "lg" { }
      # fish
      ''
        set -l remotes (${gitCmd} remote)

        if contains -- upstream $remotes
        end
      '';
in
{
  home.packages = [ script ];
}
