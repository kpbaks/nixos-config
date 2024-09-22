{ config, pkgs, ... }:
{
  home.sessionVariables = {

    # I do not like that the default is to use ~/go, if not specified.
    # Use ~/.local/share/go instead.
    # https://go.dev/wiki/SettingGOPATH
    # GOPATH = config.xdg.dataHome."go";
    GOPATH = "~/.go";
  };

  home.packages = with pkgs; [
    # TODO: figure out how this works and see if it can be duplicated for other languages
    gops # A tool to list and diagnose Go processes currently running on your system
    # gore 
    # gosu
    # godef
    # mmt
  ];
}
