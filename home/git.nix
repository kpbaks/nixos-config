{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    delta
    ghorg
    # ghostie
    github-backup
    github-to-sqlite
    glab
  ];

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-eco
      gh-markdown-preview
      # gh-notify
      gh-cal
      # gh-f
      # gh-poi
      gh-actions-cache
      # gh-copilot
      gh-screensaver
    ];

    settings.git_protocol = "https"; # or "ssh"
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
    # catppuccin.enable = false;
  };
  programs.lazygit = {
    enable = true;
    # catppuccin.enable = false;
    # git:
    #   paging:
    #     externalDiffCommand: difft --color=always --display=inline --syntax-highlight=off
    settings = {
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#using-external-diff-commands
      # git.pagint.externalDiffCommand = "difft --color=always --display=inline --syntax-highlight=off";
      git.pagint.externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
      #   gui.theme = {
      #     lightTheme = true;
      #   };
    };
  };

  programs.jujutsu.enable = false;
  programs.git-credential-oauth.enable = false;

  xdg.configFile."ghorg/config.yaml".source = (pkgs.formats.yaml { }).generate "ghorg-config" {

  };
}
