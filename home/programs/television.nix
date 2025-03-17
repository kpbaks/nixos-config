# https://github.com/alexpasmantier/television
{ pkgs, ... }:
{
  home.packages = with pkgs; [ television ];

  xdg.configFile."television/config.toml".source =
    (pkgs.formats.toml { }).generate "television-config"
      {
        ui = {
          ui_scale = 95;
          use_nerd_font_icons = true;
          theme = "tokyonight";
        };
        # A list of available themes can be found in the https://github.com/sharkdp/bat
        previewers.file.theme = "Visual Studio Dark+";
      };
}
