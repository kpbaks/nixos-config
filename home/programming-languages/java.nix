{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # openjdk_headless
    openjdk23_headless
    sonarlint-ls
    sonar-scanner-cli
    # maven
    ant
    # gradle

    # linters
    checkstyle
    pmd
  ];
}
