{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.ghostty.packages.${pkgs.stdenv.system}.default ];
}
