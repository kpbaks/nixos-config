{ inputs, ... }:
{

  imports = [ inputs.walker.homManagerModules.default ];

  # home.packages = with pkgs; [ walker ];

  # home.sessionVariables = {
  #   WALKER_CONFIG_TYPE = "toml";
  # };

  # home.packages = with pkgs; [ walker ];
  # TODO: improve style
  programs.walker = {
    enable = true;
    runAsService = true;
    config = { };
    # theme = "catppuccin";
  };
}
