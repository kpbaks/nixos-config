{ config, pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "systemd-units" { }
      # nu
      ''
        def main [
          -u|--user: bool
        ] {
          let units = (${pkgs.systemd}/bin/systemctl list-units --no-pager --output=json | from json)

          $units
          | update active {|row|
            match $row.active {
              "active" => {}
              "failed" => {}
              _ => {}
            }

            $row.active
          }
          | insert type {|row|
            $unit | split chars | enumerate


            
          }
        }
      '';
in
{
  home.packages = [ script ];

  # programs.nushell.extraConfig = # nu
}
