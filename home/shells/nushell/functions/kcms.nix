{ pkgs, ... }:
{
  programs.nushell.extraConfig =
    let
      kcmshell = "${pkgs.kdePackages.kcmutils}/bin/kcmshell6";
    in

    # # nu
    ''
      def "kcm list" []: nothing -> table<value: string, description: string> {
        ${kcmshell} --list
        | lines
        | skip 1
        | parse --regex "^(?<value>\\w+) +- (?<description>.+)"
        | sort-by value
      }

        # module: string@"kcm list | rename --column {name: value}"
      def "kcm open" [
        module: string@"kcm list"
      ] {
        ${kcmshell} $module
      }
    '';
}
