{ config, pkgs, ... }:
let
  cargo-bins =
    pkgs.writers.writeFishBin "cargo-bins" { }
      # fish
      ''
        ${pkgs.cargo}/bin/cargo run --bin &| string replace --regex --filter '^\s+' ""
      '';
  cargo-examples =
    pkgs.writers.writeFishBin "cargo-examples" { }
      # fish
      ''
        ${pkgs.cargo}/bin/cargo run --example &| string replace --regex --filter '^\s+' ""
      '';
  cargo-tests =
    pkgs.writers.writeFishBin "cargo-tests" { }
      # fish
      ''
        ${pkgs.cargo}/bin/cargo test --test &| string replace --regex --filter '^\s+' ""
      '';

in
{
  home.sessionVariables.CARGO_HOME = "${config.home.homeDirectory}/.cargo";

  home.packages =
    with pkgs;
    [
      pkgs.rust-bin.stable.latest.default
      gdb
      mold # modern linker
      # rustup # rust toolchain manager
      # rust
      clang

    ]
    ++ [
      cargo-bins
      cargo-examples
      cargo-tests
    ];
}
