{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake # C/C++ build system generator
    ninja # small build system with a focus on speed
    clang-tools
    clang-uml
    mermaid-cli # needed by `clang-uml`
    plantuml # needed by `clang-uml`
  ];
}
