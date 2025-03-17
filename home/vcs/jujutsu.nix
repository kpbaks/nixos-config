{ config, ... }:
{
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
    };
  };
}
