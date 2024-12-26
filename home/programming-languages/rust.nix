{ config, pkgs, ... }:
{
  home.sessionVariables.CARGO_HOME = "${config.home.homeDirectory}/.cargo";

  home.packages = with pkgs; [
    pkgs.rust-bin.stable.latest.default
    gdb
    mold # modern linker
    # rustup # rust toolchain manager
    # rust
    clang
  ];
}
