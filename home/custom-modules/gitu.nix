{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gitu;
  tomlFormat = pkgs.formats.toml { };
in
with lib;
{
  options.programs.gitu = {
    enable = mkEnableOption "A TUI Git client inspired by Magit";
    settings = mkOption {
      type = tomlFormat.type;
      default = { };
      # example = ;
      description = '''';
    };
  };

  config = {
    home.packages = with pkgs; [ gitu ];
    xdg.configFile."gitu/config.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "gitu-config" cfg.settings;
    };
  };

}
