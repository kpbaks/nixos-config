{ config, pkgs, ... }:
{
  # I do not like that the default is to use ~/go, if not specified.
  # Use ~/.local/share/go instead.
  # https://go.dev/wiki/SettingGOPATH
  home.sessionVariables.GOPATH = "${config.xdg.dataHome}/go";

  programs.fish.shellInit = "fish_add_path ${config.home.sessionVariables.GOPATH}";

  # TODO: use `programs.go.enable ` instead
  home.packages = with pkgs; [
    go
    # TODO: figure out how this works and see if it can be duplicated for other languages
    gops # A tool to list and diagnose Go processes currently running on your system
    # gore 
    # gosu
    # godef
    # mmt
  ];
}
