{ lib, pkgs, ... }:
let
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

  # TODO: enforce these with `lib.mkForce`
  programs.fish.shellAliases = lib.mkForce {
    ls = ''${pkgs.eza}/bin/eza ${eza-common-opts} $argv'';
    ll = ''${pkgs.eza}/bin/eza --long ${eza-common-opts} $argv'';
    la = ''${pkgs.eza}/bin/eza --almost-all ${eza-common-opts} $argv'';
  };
}
