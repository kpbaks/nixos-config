{ config, pkgs, ... }:
let
  ls-pkg-config-path =
    pkgs.writers.writeFishBin "ls-pkg-config-path" { }
      # fish
      ''
            if not set -qx PKG_CONFIG_PATH
              printf "%serror%s: \$PKG_CONFIG_PATH not set\n" (set_color red) (set_color normal) >&2
            end

        	${config.programs.eza.package}/bin/eza --tree $PKG_CONFIG_PATH
      '';
in
{
  home.packages = [ ls-pkg-config-path ];
}
