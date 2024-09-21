{ config, ... }:
{
  home.sessionVariables = {

    # I do not like that the default is to use ~/go, if not specified.
    # Use ~/.local/share/go instead.
    # https://go.dev/wiki/SettingGOPATH
    GOPATH = config.xdg.dataHome."go";
  };
}
