{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ lla ];

  xdg.configFile."lla/config.toml".source = (pkgs.formats.toml { }).generate "lla-config" {
    default_sort = "name";
    default_format = "default";
    plugins_dir = "${config.xdg.cacheHome}/lla/plugins";
    show_icons = true;
    enabled_plugins = [
      "git_status"
      "file_hash"
      "file_tagger"
    ];
  };
}
