{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "niri-pick-color";
  cacheFile = "${config.xdg.cacheHome}/${name}/previously-selected-colors.csv";
  script =
    pkgs.writers.writeFishBin name
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            config.programs.niri.package
            pkgs.pastel
            pkgs.wl-clipboard
            pkgs.libnotify
          ]}"
        ];
      }
      # fish
      ''
        mkdir -p (path dirname ${cacheFile})

        for arg in $argv
          switch $arg
            case list
              set -l nc (set_color normal)
              tail +2 ${cacheFile} | while read --delimiter , timestamp color
                set color (string sub --start=2 --end=-1 $color) # Remove quotes around "#ffffff"
                printf '%s %s%s%s\n' $timestamp (set_color --bold --background $color) $color $nc
              end
              exit 0
          end
        end

        niri msg action toggle-debug-tint
        function cleanup --on-event fish_exit
          niri msg action toggle-debug-tint
        end

        set -l color (niri msg pick-color | string match --regex --groups-only "^Hex: #(.+)")
        test $pipestatus[1] -eq 0; or exit 1

        wl-copy "$color"
        notify-send ${name} "Picked $color and copied it to your clipboard"

        test -f ${cacheFile}; or echo '"timestamp","color"' > ${cacheFile}
        set -l timestamp (date +%s)
        echo "$timestamp,\"$color\"" >> ${cacheFile}

        if isatty stdout
          function run
            echo $argv | fish_indent --ansi
            eval $argv
          end
          run pastel color "$color"
          run pastel complement "$color"
        end

        niri msg action do-screen-transition
      '';
in
{
  home.packages = [ script ];

  xdg.desktopEntries.${name} = {
    name = "niri - Pick color";
    exec = lib.getExe script;
    terminal = false;
    type = "Application";
    categories = [ "System" ];
    # TODO: upstream support for missing keys in xdg desktop entry spec v1.5
    # https://specifications.freedesktop.org/desktop-entry-spec/1.5/
    # onlyShowIn = [ "niri" ];
  };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    # Same keybind as Windows PowerToys
    "Mod+Shift+C".action = spawn (lib.getExe script);
  };
}
