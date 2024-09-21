{
  config,
  pkgs,
  ...
}:
{
  imports = [ ];

  options = { };

  config = { };

  xdg.configFile."dust/config.toml".source = (pkgs.formats.toml { }).generate "dust-config" {
    bars-on-right = true;
    reverse = true;
  };

}

# xdg.configFile."dust/config.toml".source = (pkgs.formats.toml { }).generate "dust-config" {
#   bars-on-right = true;
#   reverse = true;
# };
