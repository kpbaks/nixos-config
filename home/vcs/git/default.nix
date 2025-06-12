# TODO: see if this can be added: https://pre-commit.com/#automatically-enabling-pre-commit-on-repositories
# If it works then upstream a home-manager option for it.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./forges
    ./lazygit.nix
    ./subcommands
    ./git-ab.nix
    ./git-glossary.nix
    ./templatedir.nix
    ./mergiraf.nix
    # ./git-semver-tags.nix
  ];

  home.packages = with pkgs; [
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
    # serie # rich git commit graph terminal
    # git-interactive-rebase-tool
    # git-branchless
    # git-brunch
    # git-branchstack
    # git-bars
    # gitleaks
    # commitizen
    # git-workspace
    # git-absorb
    # lighttpd # needed by `git instaweb`
    # dependabot-cli
    # git-doc
    # sublime-merge
  ];

  programs.git.mergiraf.enable = true;

  # TODO: create wrapper script that uses `kitty` for diff program, if `git diff` is called in a kitty window,
  # and uses difftastic otherwise.
  # https://sw.kovidgoyal.net/kitty/kittens/diff/#integrating-with-git
  programs.git = {
    enable = true;
    # package = pkgs.git.override { guiSupport = true; };
    package = pkgs.git;
    userName = config.home.username;
    userEmail = config.personal.email;
    extraConfig = {
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
      tag.sort = "version:refname";
      help.format = "man";
      help.autoCorrect = "prompt";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      push = {
        autoSetupRemote = true;
        default = "nothing";
        followTags = true;
        negotiate = true;
      };

      fetch.prune = true; # always behave as if `--prune` was set
      fetch.pruneTags = true;
      fetch.recurseSubmodules = "on-demand";
      fetch.output = "compact";
      fetch.all = true;
      grep.patternType = "perl";
      grep.lineNumber = true;
      blame.coloring = "highlightRecent";
      blame.showEmail = false;
      # feature.experimental = true;
      # push.gpgSign = false;
      # sequence.editor = "${lib.getExe pkgs.git-interactive-rebase-tool}";
      init.defaultBranch = "main";
      # pull.ff = "only";
      pull.rebase = false;
      merge.conflictstyle = "zdiff3";
      merge.tool = "smerge"; # sublime merge
      # mergetool.smerge.path = "${lib.getExe pkgs.sublime-sublime-merge}";
      # rebase.autostash = true;
      commit.verbose = true;
      rebase.stat = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      stash.showStat = true;
      status.branch = true;
      status.aheadBehind = true;
      status.showStash = true;
      status.submoduleSummary = true;
      tag.forceSignAnnotated = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      # https://graphite.dev/guides/git-blame-ignore-revs
      blame.ignoreRevsFile = ".git-blame-ignore-revs";
    };

    # TODO: how to handle subshells across shells e.g. `$(...)` in bash and `()` in fish
    aliases = rec {
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
      track-untracked = "add --intent-to-add (git ls-files --others --exclude-standard)";
    };
    attributes = [ "*.pdf diff=pdf" ];
    delta = {
      enable = true;
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
    difftastic = {
      enable = false;
      display = "side-by-side-show-both";
    };

    lfs.enable = true;
    ignores = [
      # "**/.envrc"
      "**/.direnv"
    ];
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
