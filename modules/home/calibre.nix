{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.calibre;
in
{
  options.programs.calibre = {
    enable = lib.mkEnableOption "calibre";
    package = lib.mkPackageOption pkgs "calibre" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
