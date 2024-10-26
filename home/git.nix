{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    delta
    ghorg
    gitflow
    # git-gui
    # tk # needed by `git citool`
    # ghostie
    github-backup
    github-to-sqlite
    glab
    serie # rich git commit graph terminal
    # TODO: try out
    git-interactive-rebase-tool
    # git-branchless
    git-brunch
    git-branchstack
    git-bars
    gitleaks
    commitizen
  ];

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-eco
      gh-markdown-preview
      # gh-notify
      # gh-cal
      # gh-f
      # gh-poi
      gh-actions-cache
      # gh-copilot
      # gh-screensaver
    ];

    # settings.git_protocol = "https"; # or "ssh"
    settings.git_protocol = "ssh"; # or "ssh"
    settings.aliases = {
      co = "pr checkout";
      conflicts = "diff --name-only --diff-filter=U --relative";
    };
  };

  programs.gh-dash.enable = true;

  # TODO: create wrapper script that uses `kitty` for diff program, if `git diff` is called in a kitty window,
  # and uses difftastic otherwise.
  # https://sw.kovidgoyal.net/kitty/kittens/diff/#integrating-with-git
  programs.git = {
    enable = true;
    userName = config.home.username;
    userEmail = config.personal.email;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      # pull.ff = "only";
      pull.rebase = false;
      merge.conflictstyle = "zdiff3";
      # rebase.autostash = true;
      commit.verbose = true;
      merge.tool = "nvimdiff";
      rebase.autosquash = true;
    };

    aliases = {
      unstage = "reset HEAD --";
    };
    attributes = [ "*.pdf diff=pdf" ];
    delta.enable = false;
    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };

    lfs.enable = true;
    ignores = [
      "**/.envrc"
      "**/.direnv"
    ];
  };

  programs.git-cliff.enable = true;
  programs.gitui = {
    enable = true;
  };
  programs.lazygit = {
    enable = true;
    # git:
    #   paging:
    #     externalDiffCommand: difft --color=always --display=inline --syntax-highlight=off
    settings = {
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#using-external-diff-commands
      # git.pagint.externalDiffCommand = "difft --color=always --display=inline --syntax-highlight=off";
      git.paging.externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always --display=inline";
      notARepository = "quit";

      gui = {
        nerdFontsVersion = "3";
        filterMode = "fuzzy";
        # windowSize = "half";

        branchColors = with config.flavor; {
          "feature" = green.hex;
          "hotfix" = maroon.hex;
          "release" = lavender.hex;
          "bugfix" = peach.hex;
          "doc" = yellow.hex;
        };

      };

      quitOnTopLevelReturn = false;
      #   gui.theme = {
      #     lightTheme = true;
      #   };

      customCommands = [
        # {
        #   key = "v";
        #   context = "localBranches";
        # }
        {
          # https://github.com/jesseduffield/lazygit/wiki/Custom-Commands-Compendium#committing-via-commitizen-cz-c
          key = "C";
          command = "${pkgs.git}/bin/git cz c";
          description = "commit with commitizen";
          context = "files";
          loadingText = "opening commitizen commit tool";
          subProcess = true;
        }
      ];
    };
  };

  programs.jujutsu.enable = true;
  programs.git-credential-oauth.enable = false;

  xdg.configFile."ghorg/config.yaml".source = (pkgs.formats.yaml { }).generate "ghorg-config" {

  };

  home.sessionVariables.GHORG_COLOR = "enabled";
}
