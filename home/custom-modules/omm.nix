{ config, pkgs, ... }:
{
  # TODO: package for nixpkgs, and create home-manager module
  # https://github.com/dhth/omm
  xdg.configFile."omm/omm.toml".source = (pkgs.formats.toml { }).generate "omm-config" {
    # db_path                 = "~/.local/share/omm/omm-w.db"
    # tl_color                = "#b8bb26"
    # atl_color               = "#fabd2f"
    # title                   = "work"
    list_density = "spacious";
    show_context = true;
    editor = config.home.sessionVariables.EDITOR;
    confirm_before_deletion = true;
    circular_nav = true;
  };
}
