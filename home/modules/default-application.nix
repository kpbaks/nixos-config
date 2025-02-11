{
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.default-application =
    let
      inherit (pkgs.lib) mkOption types;
      package = mkOption { type = types.package; };
    in
    {
      terminal = package;
      browser = package;
    };
  config.default-application = {
    # terminal = pkgs.kitty;
    # terminal = config.programs.kitty.package;
    # terminal = pkgs.kdePackages.konsole;
    # terminal = config.programs.wezterm.package;
    # terminal = config.programs.foot.package;
    # terminal = config.programs.alacritty.package;
    terminal = pkgs.ghostty;
    browser = inputs.zen-browser.packages.${pkgs.system}.default;
  };
}
