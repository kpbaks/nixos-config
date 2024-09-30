{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "bluetooth-devices" { }
      # nu
      ''
        def devices-with-property [p: string]: nothing -> table {
          let p = ($p | str title-case)

          ${pkgs.bluez}/bin/bluetoothctl devices $p | parse "Device {uuid} {name}"
        }

        let paired: table<name: string, uuid: string, paired: bool> = devices-with-property "paired"
        let bonded: table<name: string, uuid: string, bonded: bool> = devices-with-property "bonded"
        let trusted: table<name: string, uuid: string, trusted: bool> = devices-with-property "trusted"
        let connected: table<name: string, uuid: string, connected: bool> = devices-with-property "connected"

        let devices = [
          $paired,
          $bonded,
          $trusted,
          $connected
        ]
        | reduce {|it, acc| $it ++ $acc }
        | uniq-by uuid


        # def bool2symbol [property_table: table]: nothing -> closure {
        #   const checkmark = $"(ansi green)🗸(ansi reset)"
        #   const xmark = $"(ansi red)✗(ansi reset)"
        #   |row: table| {
        #     if $row.uuid in $property_table.uuid {
        #       $checkmark
        #     } else {
        #       $xmark
        #     }
        #   }
        # }

        def bool2symbol [row: record<name: string, uuid: string>, property_table: table]: nothing -> string {
          const checkmark = $"(ansi green)🗸(ansi reset)"
          const xmark = $"(ansi red)✗(ansi reset)"
          if $row.uuid in $property_table.uuid {
            $checkmark
          } else {
            $xmark
          }
        }

        $devices
        | insert bonded {|row| bool2symbol $row $bonded} 
        | insert connected {|row| bool2symbol $row $connected} 
        | insert paired {|row| bool2symbol $row $paired} 
        | insert trusted {|row| bool2symbol $row $trusted} 
        # | insert bonded {|row| $row.uuid in $bonded.uuid }
        # | insert connected {|row| $row.uuid in $connected.uuid }
        # | insert paired {|row| $row.uuid in $paired.uuid }
        # | insert trusted {|row| $row.uuid in $trusted.uuid }
        | move name --before uuid
        | update uuid {|row| 
          let first2 = ($row.uuid | str substring 0..1)
          let last2 = ($row.uuid | str substring (-2)..)
          let inbetween = ($row.uuid | str substring 2..-3)
          # let rest = ($row.uuid | str substring 2..)
          # $"(ansi yellow)($first2)(ansi reset)(ansi d)($rest)(ansi reset)"
          $"(ansi yellow)($first2)(ansi reset)(ansi d)($inbetween)(ansi reset)(ansi blue)($last2)(ansi reset)"
        }
        | sort-by name
      '';
in
{
  home.packages = [ script ];
}
