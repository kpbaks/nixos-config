{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.neohtop;
in
{
  options.programs.neohtop = {
    enable = lib.mkEnableOption "neohtop";
    package = lib.mkPackageOption pkgs "neohtop" { };
  };

  # TODO: create issues:
  # 1. `/` or `ctrl+f` should focus the search input
  # 2. The filtered search result should highlight the parts of the query that matches

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
