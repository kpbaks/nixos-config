{
  self,
  config,
  pkgs,
  ...
}:
let
  git = "${config.programs.git.package}/bin/git";
  delta = "${config.programs.delta.package}/bin/delta";
  mergiraf = "${config.programs.mergiraf.package}/bin/mergiraf";
in
{
  programs.lazygit = {
    enable = true;
    # changeDirOnExit = true;
    settings = {
      promptToReturnFromSubprocess = false;
      confirmOnQuit = false;
      update = {
        method = "never";
      };
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#using-external-diff-commands
      git = {
        signOff = true;
        merging = {
          args = "--no-ff";
        };
        skipHookPrefix = "WIP!";
        parseEmoji = true;
        branchLogCmd = ''${git} log --all --oneline --graph --color=always --abbrev-commit --date=relative --decorate {{branchName}} --'';

        # paging.externalDiffCommand = "${config.programs.difftastic.package}/bin/difft --color=always --display=inline";
        pagers = [
          {
            pager = ''${delta} --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
          }
          {
            useExternalDiffGitConfig = true;
          }
        ];
      };
      notARepository = "quit";
      disableStartupPopups = false;

      gui = {
        nerdFontsVersion = "3";
        showNumstatInFilesView = true;
        expandFocusedSidePanel = true;
        showBottomLine = true;
        showBranchCommitHash = true;
        showDivergenceFromBaseBranch = "arrowAndNumber";
        filterMode = "fuzzy";
        border = "single";
        statusPanelView = "allBranchesLog";
        spinner.frames = [
          "⣷"
          "⣯"
          "⣟"
          "⡿"
          "⢿"
          "⣻"
          "⣽"
          "⣾"
        ];
        sidePanelWidth = 0.5;
        # windowSize = "half";

        theme = {
          activeBorderColor = [
            "yellow"
            "bold"
          ];
          inactiveBorderColor = [ "black" ];
        };

        mainBranches = [
          "master"
          "main"
        ];

        # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#color-attributes
        branchColorPatterns = {
          "^(main|master)$" = "red";
          # "^(${builtins.concatStringsSep "|" gui.mainBranches})$" = "red";
          "'^docs/'" = "#11aaff"; # use a light blue for branches beginning with 'docs/'
          "ISSUE-\d+" = "#ff5733"; # use a bright orange for branches containing 'ISSUE-<some-number>'
          "^feature/" = "green";
          "^feat/" = "green";
          "^hotfix/" = "red";
          "^bugfix/" = "yellow";
          "^release/" = "magenta";
        };
      };

      os = {
        # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-command-for-copying-to-and-pasting-from-clipboard
        copyToClipboardCmd = ''printf "\033]52;c;$(printf {{text}} | base64 -w 0)\a" > /dev/tty'';
      };

      quitOnTopLevelReturn = false;

      customCommands = [
        {
          # TODO: add command to use `git-absorb`
          key = "<c-a>";
          context = "files";
          description = "git absorb";
          command = "${pkgs.git-absorb} --one-fixup-per-commit";
          output = "logWithPty";
        }
        {
          key = "m";
          context = "files";
          description = "resolve merge conflicts with `mergiraf solve`";
          # TODO: constrain to only be available on files with merge conflict markers
          command = "${mergiraf} solve {{.SelectedFile.Name | quote}}";
          output = "logWithPty";
          # after.checkForConflicts = true;
        }
        {
          key = "d"; # TODO: rebind build in 'd' to delete branch. d -> D
          context = "localBranches";
          output = "terminal";
          command = "${git} branch --edit-description {{.SelectedLocalBranch | quote}}";
        }
        {
          key = "n";
          context = "localBranches";
          prompts = [
            {
              type = "menu";
              title = "What kind of branch is it?";
              key = "BranchType";
              options = [
                {
                  name = "feature";
                  description = "a feature branch";
                  value = "feature";
                }
                {
                  name = "hotfix";
                  description = "a hotfix branch";
                  value = "hotfix";
                }
                {
                  name = "release";
                  description = "a release branch";
                  value = "release";
                }
              ];
            }
            {
              type = "input";
              # TODO: can {{.Form.BranchType}} be used here?
              title = "What is the new branch name?";
              key = "BranchName";
              initialValue = "";
            }
          ];
          command = ''${git} branch "{{.Form.BranchType}}/{{.Form.BranchName}}" && ${git} branch --edit-description "{{.Form.BranchType}}/{{.Form.BranchName}}"'';
          loadingText = "Creating branch";
          output = "terminal";
        }
      ];

      keybinding = {
        universal = {
          nextBlock = "n";
          prevBlock = "N";
        };
        branches = {
          deleteBranch = "D"; # Just a guess for what the action is called (cannot find it in https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md ...😡)
        };
      };
    };
  };

  home.shellAliases.lg = "${config.programs.lazygit.package}/bin/lazygit";
  # programs.nushell.extraConfig = "alias lg = ${config.programs.lazygit.package}/bin/lazygit";
  programs.fish.shellAbbrs.lg = "lazygit";
}
