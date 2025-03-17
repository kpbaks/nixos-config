# https://github.com/helix-editor/helix/issues/8681
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hx = lib.getExe pkgs.helix;
  # pkgs.inotifywait
  # pkgs.watchexec
  hx-wrapper =
    pkgs.writers.writeFishBin "_hx_wrapper" { }
      # fish
      ''
        ${hx} $argv
        set -g config_files
        function watch_file_if_exists -a file
          test -f $file; and set -a config_files $file
        end
        watch_file_if_exists .helix/config.toml
        watch_file_if_exists .helix/languages.toml
        watch_file_if_exists ${config.xdg.configHome}/helix/config.toml
        watch_file_if_exists ${config.xdg.configHome}/helix/languages.toml

        if test (count $config_files) -gt 0
        # Setup inotify process that runs pkill -USR1 hx
        # TODO: do not send updates to other processes if their $PWD does not match the dirname of the config file that changed
        end

        echo "this is a wrapper script"
      '';

in

{
  programs.helix.package = hx-wrapper;
}
