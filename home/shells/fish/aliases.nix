{
  config,
  lib,
  ...
}:
let
  eza = "${config.programs.eza.package}/bin/eza";
  eza-common-opts = builtins.concatStringsSep " " [
    "--icons"
    "--group-directories-first"
    "--color-scale"
    "--sort=modified"
    "--dereference"
    "--git"
    "--git-repos"
    "--color-scale-mode=gradient"
    "--header"
    "--show-symlinks"
  ];
in
{

  programs.fish.shellAliases = lib.mkForce {
    ls = ''${eza} ${eza-common-opts} $argv'';
    ll = ''${eza} ${eza-common-opts} --long $argv'';
    la = ''${eza} ${eza-common-opts} --almost-all $argv'';
  };
}
