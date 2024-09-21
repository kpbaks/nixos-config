{ pkgs, ... }:
{

  # FIXME: something is incorrect
  # TODO: upstream to home-manager
  xdg.configFile."erdtree/.erdtree.toml".source = (pkgs.formats.toml { }).generate "erdtree-config" {
    icons = true;
    human = true;
    git = true;
    # dir-order = "first";
    long = true;
  };
}
