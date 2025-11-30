# TODO: see if this can be added: https://pre-commit.com/#automatically-enabling-pre-commit-on-repositories
# If it works then upstream a home-manager option for it.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./forges
    ./hooks
    ./lazygit.nix
    ./subcommands
    ./git-ab.nix
    ./git-glossary.nix
    ./templatedir.nix
    ./mergiraf.nix
    # ./git-semver-tags.nix
  ];

  home.packages =
    with pkgs;
    [
      meld # `git mergetool`
      sublime-merge # `git mergetool smerge`
      # gitbutler
      # gitoxide
      delta
      difftastic
      mergiraf
      # ghorg
      # gitflow
      # git-gui
      # tk # needed by `git citool`
      # ghostie
      # github-backup
      # github-to-sqlite
      serie # rich git commit graph terminal
      # git-interactive-rebase-tool
      # git-branchless
      # git-brunch
      # git-branchstack
      # git-bars
      git-absorb
      # lighttpd # needed by `git instaweb`
      # dependabot-cli
      # git-doc
    ]
    ++ (builtins.attrValues inputs.git-subcommands.packages.${pkgs.stdenv.system});

  # programs.git.mergiraf.enable = true;

  # TODO: create wrapper script that uses `kitty` for diff program, if `git diff` is called in a kitty window,
  # and uses difftastic otherwise.
  # https://sw.kovidgoyal.net/kitty/kittens/diff/#integrating-with-git
  programs.git = {
    enable = true;
    # package = pkgs.git.override { guiSupport = true; };
    package = pkgs.git;

    settings = {
      advice = {
        detachedHead = true;
      };
      feature.experimental = true;
      user = {
        name = config.home.username;
        email = config.personal.email;
      };
      core = {
        whitespace = "trailing-space,space-before-tab";
        # fsmonitor = true;
        # untrackedCache = true;
      };
      # core.fsmonitor = true;
      # core.untrackedCache = true;
      color.ui = "auto";
      color.branch.current = "yellow bold";
      color.branch.local = "dim";
      color.branch.remote = "blue ul";
      # color.branch.plain
      # color.branch.reset
      color.branch.upstream = "blue reverse";
      color.branch.worktree = "cyan";
      color.diff.meta = "yellow bold";
      color.diff.frag = "magenta bold";
      color.diff.old = "red bold";
      color.diff.new = "green bold";
      color.status.untracked = "blue dim";
      color.status.unmerged = "red reverse";
      color.status.updated = "yellow";
      # Because the phrase "Detached HEAD" isn't unnerving enough
      color.status.nobranch = ''bold ul blink red'';
      # color.status.branch = "";
      # color.status.remoteBranch = "";
      # color.status.localBranch = "";
      # color.status.noBranch = "";
      # color.status.header = "";
      # color.branch.
      color.push.error = "red bold";
      color.advice.hint = "magenta bold";
      column.ui = "auto";
      branch.sort = "-committerdate";
      help.format = "man";
      help.autoCorrect = "prompt";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      push = {
        autoSetupRemote = true;
        # default = "nothing"; # NOTE: disable until this lazygit issue has been resolved (https://github.com/jesseduffield/lazygit/issues/3140)
        followTags = true;
        negotiate = true;

      };
      remote = {
        # `git config --add remote.origin.push refs/notes/*`
        # Automatically push notes created with `git notes`
        # https://risadams.com/blog/2025/04/17/git-notes/#:~:text=To%20make%20this%20easier%2C%20add%20a%20configuration%20to%20push%20notes%20automatically
        origin.push = "refs/notes/*";
      };

      fetch.prune = true; # always behave as if `--prune` was set
      fetch.pruneTags = true;
      fetch.recurseSubmodules = "on-demand";
      fetch.output = "compact";
      fetch.all = true;
      grep = {
        patternType = "perl";
        lineNumber = true;
        column = true;
        fullname = true;
      };
      blame.coloring = "highlightRecent";
      blame.showEmail = false;
      # feature.experimental = true;
      # push.gpgSign = false;
      # sequence.editor = "${lib.getExe pkgs.git-interactive-rebase-tool}";
      init.defaultBranch = "main";
      # pull.ff = "only";
      pull.rebase = false;
      merge.conflictstyle = "diff3"; # NOTE: we want to use diff3 and not zdiff3 as `mergiraf` requires diff3 (https://mergiraf.org/usage.html)
      merge.tool = "meld";

      # mergetool.smerge.path = "${lib.getExe pkgs.sublime-sublime-merge}";
      mergetool = {
        prompt = false;
        keepBackup = false;
      };
      # rebase.autostash = true;
      commit.verbose = true;
      rebase = {
        stat = true;
        abbreviateCommands = true;
        autoSquash = true;
        autoStash = true;
        updateRefs = true; # Needed for "stacked branches" https://github.com/jesseduffield/lazygit/blob/master/docs/Stacked_Branches.md
      };
      stash.showStat = true;
      # stash.showPatch = true;
      #
      status.branch = true;
      status.aheadBehind = true;
      status.showStash = true;
      status.submoduleSummary = true;
      # status.showUntrackedFiles = "no";
      tag.forceSignAnnotated = true;
      tag.gpgSign = true;
      tag.sort = "version:refname";

      rerere = {
        enabled = true;
        autoupdate = true;
      };
      # https://graphite.dev/guides/git-blame-ignore-revs
      blame.ignoreRevsFile = ".git-blame-ignore-revs";
      url = {
        "ssh://git@github.com".insteadOf = "gh";
        "ssh://git@gitlab.com".insteadOf = "glab";
        "ssh://git@codeberg.org".insteadOf = "codeberg";
        "ssh://git@gitlab.com:beumer-group/../data-analytics".insteadOf = "da";
      };

      # TODO: how to handle subshells across shells e.g. `$(...)` in bash and `()` in fish
      aliases = rec {
        b = "branch -vv";
        ba = "${b} --all";
        be = "branch --edit-description";
        ls = "log --graph --oneline";
        la = "${ls} --all";
        wta = "worktree add";
        wtl = "worktree list";
        wtr = "worktree remove";
        unstage = "reset HEAD --";
        # downloads commits and trees while fetching blobs on-demand
        # this is better than a shallow git clone --depth=1 for many reasons
        clone-partial = "clone --filter=blob:none";
        # fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup"
        # https://jordanelver.co.uk/blog/2020/06/04/fixing-commits-with-git-commit-fixup-and-git-rebase-autosquash/
        # fixup = "!${config.programs.git.package}/bin/git log -n 50 --pretty=format:'%h %s' --no-merges | ${config.programs.fzf.package}/bin/fzf --ansi";
        track-untracked = "!git add --intent-to-add $(git ls-files --others --exclude-standard)";
        # ref: https://stackoverflow.com/a/5189296
        first-commit = "rev-list --max-parents=0 HEAD";
        first = "rev-list --max-parents=0 HEAD";
        # (r)emove (u)ntracked (f)iles
        ruf = "!git ls-files --other --exclude-standard | xargs rm -rf";
        dirty = "diff --quiet";
      };

      trailer = {
        # Configure a shorthand for adding common trailers
        # git config trailer.issue.key "Issue"
        # git config trailer.issue.ifExists "replace"
        # # Now you can use:
        # git commit --trailer "issue=#789"
        issue = {
          key = "Issue";
          ifExists = "replace";
        };
      };
    };

    # attributes = [ "*.pdf diff=pdf" ];

    lfs.enable = true;
    ignores = [
      # "**/.envrc"
      "**/.direnv"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
      };
      features = "decorations";
      whitespace-error-style = "22 reverse";
    };
  };

  programs.difftastic = {
    enable = false;
    # enableGitIntegration = false;
    options.display = "side-by-side-show-both";
  };

  programs.git-cliff.enable = true;
  programs.gitui = {
    enable = true;
    # TODO: wrap to always be called with the flag --watcher
    package = pkgs.gitui;
    # TODO: add pr to home-manager to be able to set `keyConfig = "vim"`, to easily
    # use that keymap configuration.
    # https://github.com/extrawurst/gitui/blob/master/vim_style_key_config.ron
    # keyConfig = "vim";
    theme =
      # ron
      ''
        (
          selection_bg: Gray,
          selection_fg: White,
          cmdbar_bg: DarkGray,
        )
      '';
  };

  programs.git-credential-oauth.enable = false;

  # TODO: upstream a module
  # xdg.configFile."ghorg/config.yaml".source = (pkgs.formats.yaml { }).generate "ghorg-config" {

  # };
  # home.sessionVariables.GHORG_COLOR = "enabled";

  programs.git-worktree-switcher.enable = false;

  # programs.gitu = {
  #   enable = true;
  #   settings = {
  #     general.show_help.enabled = true;
  #   };
  # };

}
