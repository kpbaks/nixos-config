{ config, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig =
      # nushell
      ''
        def "go env" [] {^go env --json | from json }
        # TODO: implement
        def modified [] {^git ls-files }

        def "config diff" [] {
          if $env.KITTY_PID? != null {
            let default_config = (^mktemp --suffix=.nu)
            config nu --default | save --force $default_config
            ^kitten diff $default_config $nu.config-path
            ^rm $default_config
          } else {
            config nu --default | ${pkgs.lib.getExe config.programs.vscode.package} --diff - $nu.config-path
          }
        }
      '';
  };
}
