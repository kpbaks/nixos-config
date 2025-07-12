{
  programs.nushell.extraConfig =
    # nu
    ''
      def lspath []: nothing -> table<dir: string, executables: int> {
        $env.PATH | split row ":"
        | wrap dir
        | insert executables { |row|
          if ($row.dir | path exists) {
            ls --long $row.dir | get mode | str substring 2..2 | where { $in == "x" } | length
          } else {
            null
          }
        }
        | update dir {|row|
          if (not ($row.dir | path exists)) {
            $"(ansi red)($row.dir)(ansi reset)"
          } else if $row.executables == 0 {
            $"(ansi yellow)($row.dir)(ansi reset)"
          } else {
            $row.dir
          }
        }
      }
    '';
}
