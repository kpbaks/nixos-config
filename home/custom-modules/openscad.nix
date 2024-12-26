{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.openscad;
in
with lib;
{
  options.programs.openscad.enable = mkEnableOption "openscad";

  config = {
    home.packages = mkIf cfg.enable (
      with pkgs;
      [
        # openscad
        openscad-unstable
        openscad-lsp
      ]
    );

    # GUI preferences
    xdg.configFile."OpenSCAD.conf".text = '''';

    home.sessionVariables = {
      # OPENSCAD_FONT_PATH
      # OPENSCADPATH
    };
  };
}
