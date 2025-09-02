# https://flow-control.dev/
{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ flow-control ];

  # TODO: create simple module for this
  # programs.flow-control = {
  #   enable = true;
  #   package = pkgs.flow-control;
  #   settings = {

  #   };
  #   # themes = [];
  #   # keys = [];
  #   # file_type = [];
  # };
}
