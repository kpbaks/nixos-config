{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    clang-uml
    mermaid-cli # needed by `clang-uml`
    plantuml # needed by `clang-uml`
  ];
}
