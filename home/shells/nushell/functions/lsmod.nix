{ pkgs, ... }:
{
  programs.nushell.extraConfig =
    # nu
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
