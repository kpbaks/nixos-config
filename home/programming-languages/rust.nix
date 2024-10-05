{ config, pkgs, ... }:
{

  home.sessionVariables.CARGO_HOME = "${config.home.homeDirectory}/.cargo";

  home.packages = with pkgs; [ ];
}
