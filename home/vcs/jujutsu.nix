{ config, pkgs, ... }:
{
  # home.packages = with pkgs; [ gg-jj ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = config.programs.git.userEmail;
        name = config.programs.git.userName;
      };
      snapshot = {
        auto-track = "none()";
      };
      aliases.init = [
        "git"
        "init"
      ];
      ui.default-command = [
        "log"
        "--reversed"
      ];
    };
  };
}
