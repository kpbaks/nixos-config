{ pkgs, ... }:
{
  # imports = lib.filesystem.listFilesRecursive ./.;
  imports = [
    ./kcms.nix
    ./lsmod.nix
    ./lspath.nix
    ./iana-media-types.nix
    ./schemastore.nix
    ./gcl.nix
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

      def "nix config show" [] {
        # This also shows the default value, and a description of the option
        # ^nix --extra-experimental-features "nix-command flakes" config show --json | from json

        ^nix --extra-experimental-features "nix-command flakes" config show
        | lines
        | parse "{option} = {value}"
        | update value {
          match $in {
            "true" => true,
            "false" => false,
            _ => {
              if $in like '^\d+$' {
                $in | into int
              } else if ($in | str contains (char space)) {
                $in | split row (char space)
              } else {
                $in
              }
            }
          }
        }
        | transpose --as-record --header-row
      }

      def "nix registry list" []: nothing -> table<name: string, registry: string, type:string, flakeref: string> {
        # TODO: add flags to enable experimental features
        # registry ::= "system" | "global" | "user"
        ^nix --extra-experimental-features "nix-command flakes" registry list
        | lines
        | parse "{registry} flake:{name} {type}:{flakeref}"
        | move name --before registry
        | update flakeref {|row| $"($row.type):($row.flakeref)"}
        | update flakeref { |row|
          match $row.type {
            "github" => {
              let parsed = $row.flakeref | parse "github:{owner}/{repo}"
              let url = $"https://github.com/($parsed.owner)/($parsed.repo)"
              $url | ansi link --text $row.flakeref
            }
            _ => $row.flakeref
          }
        }
      }

      # TODO: parse the name column and extract a corporation name like "Intel Corporation"
      def lspci []: nothing -> table<pciid: string, bus: int, device: int, function: int, type: string, name: string> {
        ${pkgs.pciutils}/bin/lspci
        | parse --regex '^(?<bus>\d+):(?<device>\d+).(?<function>\d+) (?<type>[^:]+):(?<name>.+)'
        | insert pciid { $"0000:($in.bus):($in.device).($in.function)" }
        | update bus { into int }
        | update device { into int }
        | update function { into int }
        | move pciid --before bus
        | sort-by type
      }
    '';
}
