{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = with pkgs; [ jjui ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = config.programs.git.settings.user.email;
        name = config.programs.git.settings.user.name;
      };
      # snapshot.auto-track = "none()";
      aliases = {
        ci = [
          "commit"
          "--interactive"
        ];
        d = [ "describe" ];
        init = [
          "git"
          "init"
        ];
        pull = [
          "git"
          "pull"
        ];
        push = [
          "git"
          "push"
          "--allow-new"
        ];
        s = [ "show" ];
        si = [
          "squash"
          "--interactive"
        ];
        t = [ "tag" ];
        u = [ "undo" ];
        v = [ "version" ];
        w = [ "workspace" ];
      };
      git = {
        push-new-bookmarks = true; # https://zerowidth.com/2025/jj-tips-and-tricks/#configs
        write-change-id-header = true; # https://blog.tangled.org/stacking (see bottom of article)
      };
      ui = {
        default-command = [
          "log"
          "--reversed"
        ];
        # https://difftastic.wilfred.me.uk/jj.html
        diff-formatter = [
          (lib.getExe config.programs.difftastic.package)
          "--color=always"
          "$left"
          "$right"
        ];
        # diff-editor = [ ":builtin" ];
      };

      # https://jj-vcs.github.io/jj/latest/config/#code-formatting-and-other-file-content-transformations
      fix.tools = {
        # `jj config set --repo fix.tools.rustfmt.enabled true`
        enabled = false;
        command = [
          "rustfmt"
          "--emit"
          "stdout"
        ];
        patterns = [ "glob:'**/*.rs'" ];
      };
    };
  };

  programs.jjui = {
    enable = true;
    settings = {
      # revisions = {
      #   # [revisions]
      #   template = "builtin_log_compact"; # overrides jj's templates.log
      #   revset = ""; # overrides jj's revsets.log

      # };
      # Leader key is '\'
      leader = {
        h = {
          help = "Help";
          send = [ "?" ];
        };
      };
      ui = {
        theme = "fire";
        tracer.enabled = true; # Experimental
      };
      preview.show_at_bottom = false;
      # TODO: implement this idea in the home-manager module and submit it
      # https://idursun.github.io/jjui/Custom-Commands.html#loading-jj-aliases-as-custom_commands-idea-from-211
      custom_commands = {
        # https://idursun.github.io/jjui/Custom-Commands.html#move-commit-up-and-down
        "move commit down" = {
          key = [ "J" ];
          args = [
            "rebase"
            "-r"
            "$change_id"
            "--insert-before"
            "$change_id-"
          ];
        };
        "move commit up" = {
          key = [ "K" ];
          args = [
            "rebase"
            "-r"
            "$change_id"
            "--insert-after"
            "$change_id+"
          ];
        };
        # https://idursun.github.io/jjui/Custom-Commands.html#new-note-commit-insert-an-empty-commit-inline-after--idea-from-278
        "new note commit" = {
          key = [ "N" ];
          args = [
            "new"
            "--no-edit"
            "-A"
            "$change_id"
          ];
        };
      };
    };
  };

  # TODO: Maybe easier to just have as a .toml file that we read in
  # https://idursun.github.io/jjui/Themes.html#example-fire-theme
  xdg.configFile."jjui/themes/fire.toml".source = tomlFormat.generate "jjui-fire-theme" {
    "text" = {
      fg = "#F0E6D2";
      bg = "#1C1C1C";
    };
    "dimmed" = {
      fg = "#888888";
    };
    "selected" = {
      bg = "#4B2401";
      fg = "#FFD700";
    };
    "border" = {
      fg = "#3A3A3A";
    };
    "title" = {
      fg = "#FF8C00";
      bold = true;
    };
    "shortcut" = {
      fg = "#FFA500";
    };
    "matched" = {
      fg = "#FFD700";
      underline = true;
    };
    "source_marker" = {
      bg = "#6B2A00";
      fg = "#FFFFFF";
    };
    "target_marker" = {
      bg = "#800000";
      fg = "#FFFFFF";
    };
    "revisions rebase source_marker" = {
      bold = true;
    };
    "revisions rebase target_marker" = {
      bold = true;
    };
    "status" = {
      bg = "#1A1A1A";
    };
    "status title" = {
      fg = "#000000";
      bg = "#FF4500";
      bold = true;
    };
    "status shortcut" = {
      fg = "#FFA500";
    };
    "status dimmed" = {
      fg = "#888888";
    };
    "revset text" = {
      bold = true;
    };
    "revset completion selected" = {
      bg = "#4B2401";
      fg = "#FFD700";
    };
    "revset completion matched" = {
      bold = true;
    };
    "revset completion dimmed" = {
      fg = "#505050";
    };
    "revisions selected" = {
      bold = true;
    };
    "oplog selected" = {
      bold = true;
    };
    "evolog selected" = {
      bg = "#403010";
      fg = "#FFD700";
      bold = true;
    };
    "help" = {
      bg = "#2B2B2B";
    };
    "help title" = {
      fg = "#FF8C00";
      bold = true;
      underline = true;
    };
    "help border" = {
      fg = "#3A3A3A";
    };
    "menu" = {
      bg = "#2B2B2B";
    };
    "menu title" = {
      fg = "#FF8C00";
      bold = true;
    };
    "menu shortcut" = {
      fg = "#FFA500";
    };
    "menu dimmed" = {
      fg = "#888888";
    };
    "menu border" = {
      fg = "#3A3A3A";
    };
    "menu selected" = {
      bg = "#4B2401";
      fg = "#FFD700";
    };
    "confirmation" = {
      bg = "#2B2B2B";
    };
    "confirmation text" = {
      fg = "#F0E6D2";
    };
    "confirmation selected" = {
      bg = "#4B2401";
      fg = "#FFD700";
    };
    "confirmation dimmed" = {
      fg = "#888888";
    };
    "confirmation border" = {
      fg = "#FF4500";
    };
    "undo" = {
      bg = "#2B2B2B";
    };
    "undo confirmation dimmed" = {
      fg = "#888888";
    };
    "undo confirmation selected" = {
      bg = "#4B2401";
      fg = "#FFD700";
    };
    "preview" = {
      fg = "#F0E6D2";
    };

  };
}
