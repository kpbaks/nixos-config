{ config, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  # cargo = "${pkgs.cargo}/bin/cargo";
  cargo = "cargo";
  cargo-bins =
    pkgs.writers.writeFishBin "cargo-bins" { }
      # fish
      ''
        ${cargo} run --bin &| string replace --regex --filter '^\s+' ""
      '';
  cargo-examples =
    pkgs.writers.writeFishBin "cargo-examples" { }
      # fish
      ''
        ${cargo} run --example &| string replace --regex --filter '^\s+' ""
      '';
  cargo-tests =
    pkgs.writers.writeFishBin "cargo-tests" { }
      # fish
      ''
        ${cargo} test --test &| string replace --regex --filter '^\s+' ""
      '';

  rustc-target-list =
    pkgs.writers.writeFishBin "rustc-target-list" { }
      # fish
      ''
        set -l targets (command rustc --print target-list)
        # IDEAS:
        # 1. highlight the target matching the current host system
        # 2. highlight the ones that are installed with the toolchain i.e. specified in `./rust-toolchain.toml`
        # 3. highlight the first part ot the target triple to sort of doing a group-by
      '';

  thirdparty-cargo-subcommands = with pkgs; [
    cargo-expand
    cargo-flamegraph
    cargo-nextest
    cargo-show-asm
    cargo-geiger
    cargo-dist
    cargo-deadlinks
    cargo-sort
    cargo-fuzz
    cargo-diet
    cargo-udeps
    cargo-watch
    cargo-bump
    cargo-bloat
    cargo-cache
    cargo-wizard
    cargo-outdated
    # cargo-pgo
  ];
in
{
  home.sessionVariables = {
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    # https://doc.rust-lang.org/cargo/reference/build-cache.html
    CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
    # https://doc.rust-lang.org/cargo/reference/build-cache.html#shared-cache
    # RUSTC_WRAPPER = "sccache";
  };

  home.packages =
    [
      # pkgs.cargo
    ]
    ++ (with pkgs; [
      # sccache
      # pkgs.rust-bin.stable.latest.default
      lldb
      gdb
      mold # modern linker
      rustup # rust toolchain manager
      pkg-config # `rust-analyzer` sometimes gives errors if it cannot find pkg-config
      openssl
      # rustc
      # rust-analyzer
      # clippy
      clippy-sarif
      clang
    ])
    ++ thirdparty-cargo-subcommands
    ++ [
      cargo-bins
      cargo-examples
      cargo-tests
      rustc-target-list
    ];

  # https://doc.rust-lang.org/cargo/reference/config.html#configuration-format
  home.file."cargo/config.toml".source = tomlFormat.generate "cargo-config" {
    alias = {
      cfg = "-Z unstable-options config get | ${pkgs.bat}/bin/bat -l toml --plain";
    };
  };
}
