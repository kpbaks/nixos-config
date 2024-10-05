{
  config,
  lib,
  pkgs,
  ...
}:
let
  plugin_names = [
    "formats"
    "polars"
    "gstat"
    "net"
    "query"
  ];
  # plugin_binaries = map (p: "nu_plugin_${p}") plugin_names;
  nu_plugin_add_statements = map (
    p: "plugin add ${lib.getExe pkgs.nushellPlugins.${p}}"
  ) plugin_names;
in
{
  programs.nushell = {
    enable = true;
    extraConfig =
      # nushell
      ''
        use std

        ${lib.concatLines nu_plugin_add_statements}

        # TODO: implement
        def modified [] { ${pkgs.git}/bin/git ls-files --others --exclude-standard }

        def "config diff" [] {
          if $env.KITTY_PID? != null {
            let default_config = (^mktemp --suffix=.nu)
            config nu --default | save --force $default_config
            ${pkgs.kitty}/bin/kitten diff $default_config $nu.config-path
            rm $default_config
          } else {
            config nu --default | ${pkgs.lib.getExe config.programs.vscode.package} --diff - $nu.config-path
          }
        }
      '';
  };

  home.packages = map (p: pkgs.nushellPlugins.${p}) plugin_names;

  # # FIXME: how to add these to nushell config?
  # home.packages = with pkgs.nushellPlugins; [
  #   formats
  #   polars
  #   gstat
  #   net
  #   query
  # ];
}
