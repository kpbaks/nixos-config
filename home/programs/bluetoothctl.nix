{ pkgs, ... }:
let

  scripts.bluetoothctl-startup =
    pkgs.writers.writeFishBin "bluetoothctl-startup" { }
      # fish
      ''
        set -l reset (set_color normal)
        set -l red (set_color red)
        set -l blue (set_color blue)
        set -l green (set_color green)
        set -l yellow (set_color yellow)
        set -l cyan (set_color cyan)
        set -l magenta (set_color magenta)
        set -l bold (set_color --bold)

        ${pkgs.bluez}/bin/bluetoothctl help
        echo

        set -l devices (${pkgs.bluez}/bin/bluetoothctl devices)

        echo "devices: $(count $devices)"

        printf '%s\n' $devices | while read _device mac name
          echo $mac | read -d : a b c d e f
          printf '- %s%s%s:%s%s%s:%s%s%s:%s%s%s:%s%s%s:%s%s%s' $green $a $reset $yellow $b $reset $red $c $reset $blue $d $reset $cyan $e $reset $magenta $f $reset
          printf ' %s%s%s\n' $bold $name $reset
        end
        echo

        # start bluetoothctl repl
        ${pkgs.bluez}/bin/bluetoothctl
      '';
in
{
  home.packages = builtins.attrNames scripts;

  # TODO: save path as a let binding to use in niri config
  home.file.".local/share/bluetoothctl/init-script".text = ''
    devices
    list
    scan on
  '';
}
