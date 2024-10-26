{ config, pkgs, ... }:
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
    # terminal = pkgs.kitty;
    # terminal = config.programs.kitty.package;
    # terminal = pkgs.kdePackages.konsole;
    # terminal = config.programs.wezterm.package;
    terminal = config.programs.foot.package;
  };
}
