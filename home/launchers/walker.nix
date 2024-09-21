{ pkgs, ... }:
{
  home.sessionVariables = {

    WALKER_CONFIG_TYPE = "toml";
  };

  home.packages = with pkgs; [ walker ];

  # TODO: write
  # xdg.configFile."walker/config.toml".source =
  #   (pkgs.formats.toml { }).generate "walker-config"
  #     {
  #     };
}
