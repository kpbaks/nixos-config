# TODO: extract into its own project `git-init+`
# TODO: refactor to use nushell to be cross-platform with support for Windows
# TODO: have a wrapper version `git new+ <dir>` that takes a directory that it creates, and then run `git init+` in
# TODO: if some of the files already exist, then respect that and ignore them i.e. be idempotent
#       Take inspiration from `bevy new` in how to present the output and handle files that already exist
{
  config,
  lib,
  pkgs,
  ...
}:
let
  bat = lib.getExe config.programs.bat.package;
  eza = lib.getExe config.programs.eza.package;
  column = "${pkgs.util-linux}/bin/column";
  git = lib.getExe config.programs.git.package;
  git-cliff = lib.getExe config.programs.git-cliff.package;
  echo = "${pkgs.coreutils}/bin/echo";
  touch = "${pkgs.coreutils}/bin/touch";
  git-init-plus =
    pkgs.writers.writeFishBin "git-init+" { }
      # fish
      ''
        if ${git} rev-parse --show-toplevel >&2 2> /dev/null
          printf "%serror%s: already inside a git repository\n" (set_color red --bold) (set_color normal) >&2
          exit 2
        end

        set -g runs 0
        if not set -q runs_total
          set -g runs_total (string match --all --regex "^\s*run " <(status filename) | count)
        end

        set -g digit_width (math "round(log($runs_total)) + 1")

        function run
          set runs (math "$runs + 1")
          printf "[%s%*d%s/%s] " (set_color blue) $digit_width $runs (set_color normal) $runs_total
          # set_color --dim
          # set_color --bold
          echo $argv | fish_indent --ansi
          # `fish_indent --ansi` will inject an escape sequence to clear formatting so we can latch onto it to clear up dimming
          set_color --dim --italics
          eval $argv
          set_color normal
          printf "\n"
        end

        # TODO: respect init.defaultObjectFormat
        # TODO: respect init.defaultBranch
        run ${git} init --object-format=sha1 --initial-branch=main
        run ${git} commit --allow-empty --message "'Initial commit'"
        # ${pkgs.coreutils}/bin/touch LICENSE

        # https://github.com/nishanths/license
        # https://github.com/azu/license-generator
        run ${lib.getExe pkgs.license-go} -o LICENSE mit

        # NOTE: needs to be after `git init` call otherwise the `--dump-config` call fails
        run ${lib.getExe pkgs.committed} --dump-config - | string replace 'style = "none"' 'style = "conventional"' > committed.toml

        printf '# %s\n' (path basename $PWD) > README.md
        echo "0.1.0" > VERSION
        ${echo} '# https://git-scm.com/docs/gitignore' >> .gitignore
        # TODO: use git config locally to have git blame use the file
        run ${git} config blame.ignoreRevsFile .git-blame-ignore-revs
        ${echo} '# https://git-scm.com/docs/git-blame#Documentation/git-blame.txt-blameignoreRevsFile' >> .git-blame-ignore-revs
        ${echo} '# example usage: https://github.com/NixOS/nixpkgs/blob/master/.git-blame-ignore-revs' >> .git-blame-ignore-revs
        ${echo} '# https://git-scm.com/docs/gitattributes' >> .gitattributes
        ${echo} '# https://git-scm.com/book/ms/v2/Customizing-Git-Git-Attributes' >> .gitattributes
        ${echo} '# https://github.com/gitattributes/gitattributes' >> .gitattributes
        # TODO: generate .mailmap file
        # TODO: respect `mailmap.file` and `mailmap.blob` git config options
        echo "# https://git-scm.com/docs/gitmailmap" >> .mailmap

        run ${git-cliff} --init
        run ${touch} typos.toml
        curl -sSL https://raw.githubusercontent.com/lycheeverse/lychee/refs/heads/master/lychee.example.toml > lychee.toml

        echo "# example from: https://docs.helix-editor.com/languages.html" >> .editorconfig
        curl -sSL https://editorconfig.org/#example-file | ${lib.getExe pkgs.htmlq} --text ".highlight > pre:nth-child(1)" | string replace --all --regex '^([^#].+)' '# $1' >> .editorconfig

        mkdir -p .helix
        touch .helix/{config,languages}.toml
        echo "# https://docs.helix-editor.com/configuration.html" >> .helix/config.toml
        echo "# https://docs.helix-editor.com/languages.html" >> .helix/languages.toml
        echo "/.helix/" >> .gitignore

        touch .gitlab-ci.yml


        # TODO: handle if flakes and experimental commands are not enabled
        # TODO: use a better template with devShells a function to run for all systems etc.
        run nix flake init --template templates#templates.trivial
        echo "# https://direnv.net/man/direnv-stdlib.1.html
        # shellcheck shell=bash
        # vim: ft=bash

        if has nix; then
          use flake
        fi

        dotenv_if_exists .env
        # Used for developer local `direnv` customization that should not
        # be upstreamed to a public forge to be shared with others.
        # E.g. loading security sensitive environment variables
        source_env_if_exists .envrc.local
        " >> .envrc
        echo "/.envrc.local" >> .gitignore

        # Ignore all files generated by this script in Docker context
        ${git} ls-files | while read file
          echo "/$file"
        end > .dockerignore
        echo "/flake.lock" >> .dockerignore

        run "PAGER= ${git} config --local --list | ${column} --table --separator ="
        run ${git} add --intent-to-add (${git} ls-files --others --exclude-standard)
        # run direnv allow
        run ${git} status --short

        # TODO: notify user which `init.templateDir` comes from
        run ${eza} .git/hooks --long

        # run ${eza} --long --all --git
      '';
in

{
  home.packages = [ git-init-plus ];
}
