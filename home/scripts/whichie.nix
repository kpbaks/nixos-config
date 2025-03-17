{ pkgs, ... }:

let
  script =
    pkgs.writers.writeFishBin "whichie" { }
      # fish
      ''
        if not argparse --min-args 1 -- $argv
          echo "whichie program [program...]" >&2
          exit 2
        end

        set -l nc (set_color normal)
        set -l dim (set_color --dim)
        set -l red (set_color red)
        # set -l command_color (set_color $fish_color_command)
        # set -l dimmed_command_color (set_color --dim $fish_color_command)
        set -l command_color (set_color green)
        set -l dimmed_command_color (set_color --dim green)

        set -l i 0
        set -l argc (count $argv)

        for arg in $argv
          set -l paths (command --search --all $arg)
          if test $status -ne 0
            printf "%s%s not found in \$PATH%s\n" $red $arg $nc >&2
            continue
          end


          # TODO: detect the index of the path in $PATH that i belongs to,
          # and print it as a prefix
          # set -l PATH_indices
          # for j in (seq (count $PATH))
          # end

          set -l paths (string replace --all --regex "^$HOME" "~" -- $paths)

          set -l dirname (path dirname $paths[1])
          set -l basename (path basename $paths[1])
          printf '%s/%s%s%s\n' $dirname $command_color $basename $nc

          for p in $paths[2..]
            set -l dirname (path dirname $p)
            set -l basename (path basename $p)
            printf '%s%s%s/%s%s%s\n' $dim $dirname $nc $dimmed_command_color $basename $nc
          end

          set i (math $i + 1)
          if test $i -lt $argc 
            echo # '\n'
          end
        end
      '';
in

{
  home.packages = [ script ];
}
