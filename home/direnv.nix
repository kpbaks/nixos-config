# `direnv` can also be configured in NixOS configuration
# with `programs.direnv.enable`
# I do it with home-manager to have the `programs.direnv.config`
# option available.
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

      # TODO: wrap the `dotenv` `source_env` and there `*_if_exists` variants, to also create
      # export variables with a `HURL_${var}` name, to support the format `hurl` expects.
      # TODO: do something flashy with a cool colorful title here.
      stdlib = # bash
        ''
          echo "loaded .envrc"
        '';
    };
  };

  home.sessionVariables = {
    # DIRENV_LOG_FORMAT = ""; # silence `direnv` msgs
  };
}
