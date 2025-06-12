{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.zotero;
in
{
  # zotero # citation/bibliography manager
  options.programs.zotero = {
    enable = lib.mkEnableOption "zotero";
    package = lib.mkPackageOption pkgs "zotero" { };

    # TODO: have option for "Allow other applications ... to communicate with Zotero"
    # using `http://localhost:23119/api/`

    # TODO: have a `.plugins = [];` option
    # https://www.zotero.org/support/plugins
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
