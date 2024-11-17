# TODO: upstream this to nixpkgs https://github.com/FMotalleb/nu_plugin_image
# TODO: upstream this to nixpkgs https://github.com/dead10ck/nu_plugin_dns
# TODO: upstream this to nixpkgs https://github.com/devyn/nu_plugin_dbus
# TODO: upstream this to nixpkgs https://github.com/yybit/nu_plugin_compress
# TODO: upstream this to nixpkgs https://github.com/yybit/nu_plugin_compress
# TODO: upstream this to nixpkgs https://github.com/fdncred/nu_plugin_emoji

{ lib, pkgs, ... }:

let
  plugin_names = [
    "formats"
    "polars"
    # "gstat"
    # "net"
    "query"
  ];
  # plugin_binaries = map (p: "nu_plugin_${p}") plugin_names;
  nu_plugin_add_statements = map (
    p: "plugin add ${lib.getExe pkgs.nushellPlugins.${p}}"
  ) plugin_names;
in
{
  programs.nushell.extraConfig = lib.concatLines nu_plugin_add_statements;
  home.packages = map (p: pkgs.nushellPlugins.${p}) plugin_names;
}
