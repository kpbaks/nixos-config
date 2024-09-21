{ pkgs, ... }:
{

  options.default-application =
    let
      inherit (pkgs.lib) mkOption types;
      package = mkOption { type = types.package; };
    in
    {
      terminal = package;
    };
  config.default-application = {
    terminal = pkgs.kitty;
  };
}
