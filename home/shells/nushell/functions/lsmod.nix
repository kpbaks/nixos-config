{ pkgs, ... }:
{
  programs.nushell.extraConfig =
    # nushell
    ''
      # lsmod
      ${pkgs.kmod}/bin/lsmod
      | lines
      | skip 1
      | parse --regex '^(?<module>\w+)\s+(?<size>\d+)\s+\d+\s+(?<used_by>\S+)'
      | sort-by module
      | update size { into filesize }
      | update used_by { split row "," }
    '';
}
