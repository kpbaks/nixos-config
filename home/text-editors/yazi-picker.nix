# https://yazi-rs.github.io/docs/tips/#helix-with-zellij
# TODO: print error or send notification if helix instance is not in zellij
{
  config,
  lib,
  pkgs,
  ...
}:

let
  zellij = "${config.programs.zellij.package}/bin/zellij";
  yazi = "${config.programs.yazi.package}/bin/yazi";
  yazi-picker-script = lib.getExe (
    pkgs.writers.writeBashBin "yazi-picker" { }
      # bash
      ''
        paths=$(${yazi} --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)
        if [[ -n "$paths" ]]; then
        	${zellij} action toggle-floating-panes
        	${zellij} action write 27 # send <Escape> key
        	${zellij} action write-chars ":$1 $paths"
        	${zellij} action write 13 # send <Enter> key
        else
        	${zellij} action toggle-floating-panes
        fi

      ''
  );
in
{

  programs.helix.settings.keys.normal."C-y" =
    let
      zellij-opts = "--close-on-exit --floating -x 10% -y 10% --width 80% --height 80%";
    in
    rec {
      y = ":sh ${zellij} run ${zellij-opts} -- ${yazi-picker-script} open";
      h = ":sh ${zellij} run ${zellij-opts} -- ${yazi-picker-script} hsplit";
      v = ":sh ${zellij} run ${zellij-opts} -- ${yazi-picker-script} vsplit";
      s = h;
    };
}
