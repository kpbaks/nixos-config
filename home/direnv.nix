# NOTE: `direnv` can also be configured in NixOS configuration
# with `programs.direnv.enable`
# I do it with home-manager to have the `programs.direnv.config`
# option available.
{ config, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # https://direnv.net/man/direnv.toml.1.html
    config = {
      strict_env = true;
      warn_timeout = "0"; # "0" will disable the message.
      hide_env_diff = true;
      # TODO: it is not clear from the docs what kind of formats
      # are valid. These should be documented.
      # Used here: https://github.com/direnv/direnv/blob/b76e297d5cbf0ec11e5d2320b2c89a981fb2b628/internal/cmd/log.go#L34-L47
      # log_format = "";

      # TODO: do something flashy with a cool colorful title here.
      stdlib = # bash
        ''
          # TODO: come up with a robust implementation and upstream it
          function use_rust() {
            # TODO: find all profiles using `cargo`
            # TODO: does the order matter with multiple builds?
            profiles=(debug release)
            for profile in $\{profiles[@]}; do
              export PATH="$\{PWD}/$\{CARGO_TARGET_DIR:-target}/$\{profile}:$\{PATH}"
            done
            [ -f rust-toolchain.toml ] && watch_file rust-toolchain.toml
            [ -f .cargo/config.toml ] && watch_file .cargo/config.toml
            watch_file Cargo.lock **/Cargo.toml
          }

          # TODO: wrap the `dotenv` `source_env` and there `*_if_exists` variants, to also create
          # export variables with a `HURL_$${var}` name, to support the format `hurl` expects.
          function use_hurl() {
            if [ -n "$direnv_hurl_used" ]; then
              return
            else
              export direnv_hurl_used=1
            fi


          }

          # use hurl

          # use rust
          function check_git_submodules_are_initialized() {
            ${config.programs.git.package}/bin/git submodule status | while read -r hash name; do
              [ \${"hash:0:1"} == - ] || continue
              log_error "git submodule '$name' is not initialized"
              log_status 'use `git submodule update --init --recursive` to initialize it'
            done
          }

          check_git_submodules_are_initialized

          if has onefetch; then
            onefetch
          fi
        '';
    };
  };

  home.sessionVariables = {
    # DIRENV_LOG_FORMAT = ""; # silence `direnv` msgs
  };
}
