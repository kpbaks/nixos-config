{
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  services.tldr-update.enable = true;

  # TODO: make module
  home.packages = with pkgs; [
    tlrc
  ];

  # TODO: create a tlrc module for hm
  # https://github.com/tldr-pages/tlrc#configuration-options
  xdg.configFile."tlrc/config.toml".source = tomlFormat.generate "tlrc-config" {
    output = {
      compact = true;
      option_style = "both";
    };
  };
}
