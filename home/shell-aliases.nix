{
  config,
  lib,
  pkgs,
  ...
}:
let
  eza = lib.getExe config.programs.eza.package;
  git = lib.getExe config.programs.git.package;
  lazygit = lib.getExe config.programs.lazygit.package;
  lazydocker = lib.getExe config.programs.lazydocker.package;
in
{
  home.shellAliases = rec {
    g = git;
    t = "${eza} --tree --dereference --group-directories-first";
    ta = "${t} --almost-all";
    t2 = "${t} --level=2";
    t3 = "${t} --level=3";
    lg = lazygit;
    lzd = lazydocker;
  };
}
