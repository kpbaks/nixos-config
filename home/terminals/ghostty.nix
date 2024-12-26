{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [ ghostty ];
  # home.packages = [ inputs.ghostty.packages.${pkgs.stdenv.system}.default ];
}
