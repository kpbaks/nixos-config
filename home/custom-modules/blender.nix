{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.blender;
in
with lib;

{
  options.programs.blender.enable = mkEnableOption "blender";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ blender ];
  };
}
