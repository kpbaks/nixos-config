{ pkgs, ... }:
let
  inherit (pkgs.lib) mkOption types;
  str = mkOption { type = types.str; };
in
{
  options.monitor = {
    laptop = str;
    primary = str;
    acer = str;
  };

  config.monitor = rec {
    laptop = "eDP-1"; # embedded DisplayPort 1. The generic name of all laptop screens on linux
    acer = "DP-6"; # FIXME: not guaranteed to be static when using a thunderbolt dock. Use full name or device uuid instead
    primary = laptop;
  };
}
