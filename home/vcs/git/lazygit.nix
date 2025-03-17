{ config, pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#using-external-diff-commands
      git = {
        parseEmoji = true;
        paging.externalDiffCommand = "${config.programs.git.difftastic.package}/bin/difft --color=always --display=inline";
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

        mainBranches = [
          "master"
          "main"
        ];
        # TODO: highlight mainBranches
        # FIXME: does not get highlighted
        branchColors = {
          "^feature/" = "#00ff00";
          "^docs/" = "#11aaff"; # use a light blue for branches beginning with 'docs/'
          "^hotfix/" = "red";
          "^bugfix/" = "yellow";
        };
        # branchColors = with config.flavor; {
        #   "feature" = green.hex;
        #   "hotfix" = maroon.hex;
        #   "release" = lavender.hex;
        #   "bugfix" = peach.hex;
        #   "doc" = yellow.hex;
        # };

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
          # FIXME: command seems wrong
          command = "${pkgs.git}/bin/git cz c";
          description = "commit with commitizen";
          context = "files";
          loadingText = "opening commitizen commit tool";
          subProcess = true;
        }
      ];
    };
  };

  programs.nushell.extraConfig = "alias lg = ${config.programs.lazygit.package}/bin/lazygit";
  programs.fish.shellAbbrs.lg = "lazygit";
}
