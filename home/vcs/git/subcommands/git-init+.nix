# TODO: maybe configure a remote to your default hosting site, and username?
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

        if not argparse v/verbose -- $argv
          # TODO: add small hint of how to use
          exit 2
        end

        # Variables set by `argparse` are bound to local scope, but we need to check
        # for it in a nested function `run`, so we set a global variable instead
        if set -q _flag_verbose
          set -g verbose
        end

        set -g runs 0
        if not set -q runs_total
          set -g runs_total (string match --all --regex "^\s*run " <(status filename) | count)
        end

        set -g digit_width (math "round(log($runs_total)) + 1")

        function run
          set runs (math "$runs + 1")
          if set -qg verbose
            # printf (printf "[%%s%%%dd%%s/%%s] " $digit_width) (set_color blue) (set_color normal) $runs $runs_total
            printf (printf "[%%%dd/%%d] " $digit_width) $runs $runs_total
            # set_color --dim
            # set_color --bold
            echo $argv | fish_indent --ansi
            # `fish_indent --ansi` will inject an escape sequence to clear formatting so we can latch onto it to clear up dimming
            set_color --dim --italics
          end
          eval $argv
          set_color normal
          set -qg verbose; and printf "\n"
        end

        # TODO: respect init.defaultObjectFormat
        # TODO: respect init.defaultBranch
        run ${git} init --object-format=sha1 --initial-branch=main
        run ${git} commit --allow-empty --message "'Initial commit'"
        # ${pkgs.coreutils}/bin/touch LICENSE

        # https://github.com/nishanths/license
        # https://github.com/azu/license-generator
        run ${lib.getExe pkgs.license-go} -o LICENSE mit

        set -l project_name (path basename $PWD)
        printf '# %s\n' $project_name > README.md
        run 'echo "0.1.0" > VERSION'
        ${echo} '# https://git-scm.com/docs/gitignore' >> .gitignore
        # TODO: use git config locally to have git blame use the file
        run ${git} config blame.ignoreRevsFile .git-blame-ignore-revs
        ${echo} '# https://git-scm.com/docs/git-blame#Documentation/git-blame.txt-blameignoreRevsFile' >> .git-blame-ignore-revs
        ${echo} '# example usage: https://github.com/NixOS/nixpkgs/blob/master/.git-blame-ignore-revs' >> .git-blame-ignore-revs
        ${echo} '# https://git-scm.com/docs/gitattributes' >> .git-attributes
        ${echo} '# https://git-scm.com/book/ms/v2/Customizing-Git-Git-Attributes' >> .git-attributes
        ${echo} '# https://github.com/gitattributes/gitattributes' >> .git-attributes

        run ${git-cliff} --init
        run ${touch} typos.toml

        # TODO: add pre-commit hooks that i want to use for every project

        # TODO: handle if flakes and experimental commands are not enabled
        # TODO: maybe use https://docs.rs/crate/minijinja-cli/latest to use a template approach
        # run nix flake init
        echo "{
          description = \"$project_name\";
          inputs = {
            nixpkgs.url = \"github:NixOS/nixpkgs/nixpkgs-unstable\";
            pre-commit-hooks = {
              url = \"github:cachix/git-hooks.nix\";
              inputs.nixpkgs.follows = \"nixpkgs\";
            };
          };
          outputs = {
            self,
            nixpkgs,
            pre-commit-hooks,
          }:
          let
            system = \"${pkgs.system}\";
            pkgs = import nixpkgs {inherit system;};
          in
          {
            devShells.\''${system}.default = pkgs.mkShell {
              name = \"$project_name\";
              packages = with pkgs; [];
            };

            formatter.\''${system} = pkgs.nixfmt-rfc-style;
          };
        }" > flake.nix

        run '${echo} "use flake" >> .envrc'

        ${git} add flake.* .envrc
        # TODO: use installed

        # ${bat} (path filter -f * .*)

        run "PAGER= ${git} config --local --list | ${column} --table --separator ="
        # run direnv allow
        run ${git} status --short

        exit 0

        # run ${eza} --long --all --git
      '';
in

{
  home.packages = [ git-init-plus ];

}
