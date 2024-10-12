{ inputs, pkgs, ... }:
let
  scls = inputs.simple-completion-language-server.defaultPackage.${pkgs.system};
in
{
  # TODO: convert
  # programs.helix.enable = true;
  # programs.helix.defaultEditor = true;
  programs.helix = {
    enable = true;
    defaultEditor = true;
    catppuccin.enable = false;
    # package = pkgs.helix;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      jq-lsp
      marksman
      taplo
      typos
      # pkgs.vscode-langservers-extracted
      dprint
      python3Packages.python-lsp-server
      python3Packages.python-lsp-ruff

      lua-language-server
      stylua
      selene
      harper
      scls
    ];

    ignores = [
      ".build/"
      "build/"
      "target/"
      ".direnv/"
    ];

    settings = {
      # theme = "catppuccin_mocha";
      # theme = "ao";
      # theme = "pop-dark";
      theme = "tokyonight";
      editor = {
        cursorline = true;
        line-number = "relative";
        lsp.display-messages = true;
        lsp.auto-signature-help = true;
        lsp.display-inlay-hints = true;
        lsp.snippets = true;
        lsp.display-signature-help-docs = true;
        completion-trigger-len = 1;
        idle-timeout = 50; # ms
        auto-info = true;
        auto-format = true;
        undercurl = true;
        mouse = true;
        preview-completion-insert = true;
        color-modes = true;
        popup-border = "all";
        gutters = [
          "line-numbers"
          "spacer"
          "diagnostics"
          "diff"
        ];
        true-color = true;
        bufferline = "always";
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning"; # show warnings and errors on the cursorline inline
        jump-label-alphabet = "fjghdkslaerioqptyuzxcvbnm";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
          git-ignore = true;
        };
        soft-wrap.enable = true;
        smart-tab = {
          enable = true;
          supersede-menu = true;
        };
        indent-guides = {
          render = true;
          character = "╎";
          skip-levels = 1;
        };
        statusline = {
          separator = "│";
          left = [
            "mode"
            "spinner"
            "version-control"
            # "selections"
            "separator"
          ];
          center = [
            "file-name"
            "file-modification-indicator"
            "diagnostics"
            # "file-type"
          ];
          right = [
            "register"
            "separator"
            "workspace-diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];

          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        search = {
          smart-case = false;
          wrap-around = true;
        };
      };
      keys.insert = {
        C-space = "signature_help";
      };
      keys.normal = {
        # y.d = [ ":yank-diagnostic" ];
        ret = [
          "open_below"
          "normal_mode"
        ];
        D = [
          "select_mode"
          "goto_line_end"
          "delete_selection"
        ];
        H = [
          "goto_line_start"
          "goto_first_nonwhitespace"
        ];
        Y = [
          "save_selection"
          "select_mode"
          "goto_line_end"
          "yank"
          "jump_backward"
        ]; # Similar to Y in nvim
        w = [
          "move_prev_word_start"
          # "select_textobject_inner",
          # "w",
          "move_next_word_start"
        ];
        W = [
          "move_prev_long_word_start"
          # "select_textobject_inner",
          # "w",
          "move_next_long_word_start"
        ];

        "*" = [
          "move_char_right"
          "move_prev_word_start"
          "move_next_word_end"
          "search_selection"
          "make_search_word_bounded"
          "search_next"
        ];
        "#" = [
          "move_char_right"
          "move_prev_word_start"
          "move_next_word_end"
          "search_selection"
          "make_search_word_bounded"
          "search_prev"
        ];
        A-down = [
          "extend_to_line_bounds"
          "yank"
          "delete_selection"
          "move_line_down"
          "paste_before"
        ];
        A-j = [
          "extend_to_line_bounds"
          "yank"
          "delete_selection"
          "move_line_down"
          "paste_before"
        ];
        A-up = [
          "extend_to_line_bounds"
          "yank"
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];
        A-k = [
          "extend_to_line_bounds"
          "yank"
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];

        space.space = "last_picker";
        space.w = ":w";
        C-s = ":w";
        # C-s = [
        #   "select_all"
        #   "pipe cat -s"
        #   ":w"
        # ];
        space.q = ":buffer-close";
        space.Q = ":buffer-close-others";
        C-q = ":q";
        space.p = "paste_clipboard_before"; # I like <space>P more as the default
        space.n = ":set-option line-number absolue";
        space.N = ":set-option line-number relative";
        space.t.i = ":toggle-option lsp.display-inlay-hints";
        space.t.w = ":toggle-option soft-wrap.enable";
        space.l = {
          r = ":lsp-restart";
          s = ":lsp-stop";
          w = ":lsp-workspace-command";
        };
        backspace = ":buffer-previous";
        a = [
          "append_mode"
          "collapse_selection"
        ]; # Similar to "a" in neovim
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ]; # use esc to remove selection, AND to collapse multiple cursors into one
        X = "extend_line_above";
        C-left = "jump_view_left";
        C-right = "jump_view_right";
        C-up = "jump_view_up";
        C-down = "jump_view_down";
        C-h = "jump_view_left";
        C-l = "jump_view_right";
        C-k = "jump_view_up";
        C-j = "jump_view_down";
        # just like in a browser
        C-home = "goto_file_start";
        C-end = "goto_file_end";
        C-pageup = "goto_previous_buffer";
        C-pagedown = "goto_next_buffer";
        g = {
          a = "code_action"; # `ga` -> show possible code actions
          q = ":reflow";
          Y = [
            "extend_line_below"
            "yank"
            "toggle_comments"
            "paste_after"
            "goto_line_start"
          ];
          H = [
            "select_mode"
            "goto_line_start"
          ];
          L = [
            "select_mode"
            "goto_line_end"
          ];
          S = [
            "select_mode"
            "goto_first_nonwhitespace"
          ];

          left = "jump_view_left";
          right = "jump_view_right";
          up = "jump_view_up";
          down = "jump_view_down";

          # "~" = "switch_case"
          u = "switch_to_lowercase";
          U = "switch_to_uppercase";
        };
        "[".b = ":buffer-previous";
        "]".b = ":buffer-next";
      };
      keys.select = {
        A-x = "extend_to_line_bounds";
        X = [
          "extend_line_up"
          "extend_to_line_bounds"
        ];
        g = {
          u = "switch_to_lowercase";
          U = "switch_to_uppercase";
        };
      };
    };

    languages = {
      language-server.clangd = {
        command = "${pkgs.clang-tools}/bin/clangd";
        args = [
          "--completion-style"
          "detailed"
          "--pretty"
          "--all-scopes-completion"
          "--clang-tidy"
        ];
      };
      language-server.quick-lint-js = {
        command = "quick-lint-js";
        args = [ "--lsp-server" ];
      };
      # https://github.com/tekumara/typos-lsp/blob/main/docs/helix-config.md
      language-server.typos-lsp = {
        command = "${pkgs.typos-lsp}/bin/typos-lsp";
        environment.RUST_LOG = "error";
        config.diagnosticSeverity = "Warning";
      };

      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";
        args = [
          "--inlay-hints"
          "--semantic-tokens"
        ];
      };

      # TODO(pr): upstream pr to both helix and harper
      language-server.harper-ls = {
        command = "${pkgs.harper}/bin/harper-ls";
      };

      language-server.nu-lsp = {
        command = "${pkgs.nushell}/bin/nu";
        args = [ "--lsp" ];
        language-id = "nu";
      };
      language-server.pyright = {
        command = "${pkgs.pyright}/bin/pyright";
      };
      language-server.ruff-lsp = {
        command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
        language-id = "python";
      };
      language-server.dprint = {
        command = "${pkgs.dprint}/bin/dprint";
        args = [ "lsp" ];
      };

      language =
        let
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        in
        [
          {
            name = "markdown";
            language-servers = [
              "typos-lsp"
              "marksman"
              "harper-ls"
            ];
            file-types = [ "qmd" ];
            formatter.command = "${pkgs.mdformat}/bin/mdformat";
          }
          {
            name = "bash";
            formatter.command = "${pkgs.shfmt}/bin/shfmt";
            auto-format = true;
            inherit indent;
          }
          {
            name = "cpp";
            auto-format = false;
            language-servers = [ "clangd" ];
            inherit indent;
          }
          {
            name = "css";
            formatter = {
              command = "${pkgs.dprint}/bin/dprint";
              args = [ "fmt" ];
            };
            language-servers = [ "dprint" ];
          }
          {
            name = "fish";
            auto-format = true;
            formatter.command = "${pkgs.fish}/bin/fish_indent";
            file-types = [ "fish" ];
          }
          {
            name = "json";
            auto-format = true;
            formatter = {
              command = "${pkgs.jaq}/bin/jaq";
              args = [ "." ];
            };
          }
          {
            name = "lua";
            auto-format = true;
            formatter.command = "${pkgs.stylua}/bin/stylua";
          }
          {
            name = "nickel";
            auto-format = true;
            formatter = {
              command = "${pkgs.nickel}/bin/nickel";
              args = [ "format" ];
            };
            inherit indent;
          }
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            };
            language-servers = [ "nixd" ];
            inherit indent;
          }
          {
            name = "nu";
            auto-format = true;
            language-servers = [
              "pyright"
              "ruff-lsp"
            ];
          }
          {
            name = "toml";
            auto-format = true;
            formatter = {
              command = "${pkgs.taplo}/bin/taplo";
              args = [
                "format"
                "-"
              ];
            };
            language-servers = [ "taplo" ];
          }
          {
            name = "yaml";
            file-types = [
              "yml"
              "yaml"
              ".clang-format"
            ];
          }
          # {
          #   name = "kitty-conf";
          #   source.git = "https://github.com/clo4/tree-sitter-kitty-conf";
          #   source.rev = "main";
          # }
        ];
    };
  };
}
