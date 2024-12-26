{ pkgs, ... }:
{
  # imports = lib.filesystem.listFilesRecursive ./.;
  imports = [
    ./kcms.nix
    ./lsmod.nix
    ./lspath.nix
    # ./from-mode.nix
  ];

  programs.nushell.extraConfig = # nu
    ''
      # TODO: parse the filesize suffix
      def "git count-objects" []: nothing -> record<count: filesize, size: filesize, in-pack: filesize, packs: filesize, size-pack: filesize, prune-packable: filesize, garbage: filesize, size-garbase: filesize> {
        ${pkgs.git}/bin/git count-objects --verbose --human-readable
        | lines
        | parse "{key}: {value}"
        | update value { into int }
        | transpose --as-record --header-row  
      }
    '';
}
