#   Render markdown on the CLI, with pizzazz!

# Usage:
#   glow [SOURCE|DIR] [flags]
#   glow [command]

# Available Commands:
#   completion  Generate the autocompletion script for the specified shell
#   config      Edit the glow config file
#   help        Help about any command

# Flags:
#   -a, --all                  show system files and directories (TUI-mode only)
#       --config string        config file (default /home/kpbaks/.config/glow/glow.yml)
#   -h, --help                 help for glow
#   -l, --line-numbers         show line numbers (TUI-mode only)
#   -p, --pager                display with pager
#   -n, --preserve-new-lines   preserve newlines in the output
#   -s, --style string         style name or JSON path (default "auto")
#   -t, --tui                  display with tui
#   -v, --version              version for glow
#   -w, --width uint           word-wrap at width (set to 0 to disable)

# Use "glow [command] --help" for more information about a command.

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gitu;
  yamlFormat = pkgs.formats.yaml { };
in
with lib;
{
  options.programs.glow = {
    enable = mkEnableOption "A terminal based markdown reader designed from the ground up to bring out the beauty—and power—of the CLI";
    settings = mkOption {
      type = yamlFormat.type;
      # https://github.com/charmbracelet/glow/blob/e83c6edf93e8d2e0fdc9585849f478bf6c8ae431/config_cmd.go#L16-L26
      default = {
        style = "auto";
        mouse = false;
        pager = false;
        width = 80;
        all = false;
      };
      # example = ;
      description = '''';
    };
  };

  config = {
    home.packages = with pkgs; [ glow ];
    # https://github.com/charmbracelet/glow#the-config-file
    xdg.configFile."glow/glow.yml" = mkIf (cfg.settings != { }) {
      source = yamlFormat.generate "glow-config" cfg.settings;
    };
  };
}
