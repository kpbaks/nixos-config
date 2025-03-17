{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    package = pkgs.bashInteractive;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "ignorespace" ];
    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];
  };
  home.shell.enableBashIntegration = true;
}
