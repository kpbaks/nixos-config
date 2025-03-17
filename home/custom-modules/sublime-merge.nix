{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.sublime-merge;
in
{
  options.programs.sublime-merge = {
    enable = lib.mkEnableOption "sublime-merge";
    settings = { };
  };

  config = {
    home.packages = lib.mkIf cfg.enable (
      with pkgs;
      [
        sublime-merge
        # openscad
      ]
    );

    # TODO: finish
    # xdg.configFile."sublime-merge/Packages/User/Preferences.sublime-settings".source = pkgs.formats.json;
    #     {
    # 	"always_show_command_status": true,
    # 	"hardware_acceleration": "opengl"
    # }
    #
    # xdg.configFile."sublime-merge/Packages/User/Commit Message.sublime-settings".source = pkgs.formats.json;

  };
}
