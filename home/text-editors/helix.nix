# TODO: deduplicate keys to work in normal and select mode like in: https://github.com/NikitaRevenco/dotfiles/blob/main/helix.nix
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  scls = inputs.simple-completion-language-server.defaultPackage.${pkgs.system};
  tree-sitter-roc = pkgs.fetchFromGitHub {
    owner = "faldor20";
    repo = "tree-sitter-roc";
    rev = "ef46edd0c03ea30a22f7e92bc68628fb7231dc8a";
    hash = "sha256-H76cnMlBT1Z/9WXAdoVslImkyy38uCqum9qEnH+Ics8=";
  };
  left-bracket = command: [
    command
    # "align_view_center"
  ];
  right-bracket = left-bracket;
in
{

  imports = [
    ./yazi-picker.nix
    # inputs.crates-lsp.homeModules.${pkgs.system}.default
  ];
  # TODO: convert
  # programs.helix.enable = true;
  # programs.helix.defaultEditor = true;
  # catppuccin.helix.enable = false;
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # package = pkgs.helix;
    # TODO: add as overlay to use as `pkgs.helix`
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
      sonarlint-ls

      stylua
      selene
      harper
      scls
      nls
      mdformat
      python313Packages.mdformat-tables
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
      # theme = "tokyonight";
      # theme = "gruvbox_dark_hard";
      theme = "kanagawa";
      # theme = "kaolin-dark";
      # theme = "gruber-darker";
      editor = {
        cursorline = true;
        line-number = "relative";
        continue-comments = true;
        lsp = {
          display-messages = true;
          display-progress-messages = true;
          auto-signature-help = true;
          display-inlay-hints = true;
          snippets = true;
          display-signature-help-docs = true;
          goto-reference-include-declaration = false;
        };
        auto-save = {
          focus-lost = true;
        };
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
          skip-levels = 0;
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
      # keys.insert = {
      #   C-space = "signature_help";
      # };
      keys.normal = {

        # ret = [ "select_references_to_symbol_under_cursor" ];
        # y.d = [ ":yank-diagnostic" ];
        #
        # up = "select_textobject_inner";
        # down = "select_textobject_around";
        # left = "@[";
        # right = "@]";
        D = [
          "select_mode"
          "goto_line_end"
          "delete_selection"
        ];
        # H = [
        #   "goto_line_start"
        #   "goto_first_nonwhitespace"
        # ];
        Y = [
          "save_selection"
          "select_mode"
          "goto_line_end"
          "yank"
          "jump_backward"
        ]; # Similar to Y in nvim
        # w = [
        #   "move_prev_word_start"
        #   # "select_textobject_inner",
        #   # "w",
        #   "move_next_word_start"
        # ];
        # W = [
        #   "move_prev_long_word_start"
        #   # "select_textobject_inner",
        #   # "w",
        #   "move_next_long_word_start"
        # ];

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
        # A-down = [
        #   "extend_to_line_bounds"
        #   "yank"
        #   "delete_selection"
        #   "move_line_down"
        #   "paste_before"
        # ];
        # A-j = [
        #   "extend_to_line_bounds"
        #   "yank"
        #   "delete_selection"
        #   "move_line_down"
        #   "paste_before"
        # ];
        # A-up = [
        #   "extend_to_line_bounds"
        #   "yank"
        #   "delete_selection"
        #   "move_line_up"
        #   "paste_before"
        # ];
        # A-k = [
        #   "extend_to_line_bounds"
        #   "yank"
        #   "delete_selection"
        #   "move_line_up"
        #   "paste_before"
        # ];

        space.space = "last_picker";
        # space.w = ":w";
        space.w = ":update";
        C-s = ":w";
        # C-s = [
        #   "select_all"
        #   "pipe cat -s"
        #   ":w"
        # ];
        space.q = ":buffer-close";
        space.Q = ":buffer-close-others";
        C-q = ":quit";
        space.p = "paste_clipboard_before"; # I like <space>P more as the default
        # space.n = ":set-option line-number absolute";
        space.N = ":set-option line-number relative";
        space.t.i = ":toggle-option lsp.display-inlay-hints";
        space.t.w = ":toggle-option soft-wrap.enable";
        space.t.n = ":toggle-option indent-guides.render";
        space.t.p = ":toggle-option lsp.display-progress-messages";
        # space.t.d = [":toggle-option "];
        space.l = {
          r = ":lsp-restart";
          s = ":lsp-stop";
          w = ":lsp-workspace-command";
        };
        # space.n = [

        #   "select_register"
        #   "/"
        # ];
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

        space."." = "code_action";
        "C-." = "code_action";

        g = {
          a = "code_action"; # `ga` -> show possible code actions
          A = ":lsp-workspace-command";
          q = ":reflow";
          Y = [
            "extend_line_below"
            "yank"
            "toggle_comments"
            "paste_after"
            "goto_line_start"
          ];
          # H = [
          #   "select_mode"
          #   "goto_line_start"
          # ];
          # L = [
          #   "select_mode"
          #   "goto_line_end"
          # ];
          S = [
            "select_mode"
            "goto_first_nonwhitespace"
          ];

          # Select the current word
          W = "@miw";
          # Move to inside the previous parenthesis
          H = "@F)mi(";
          # Move to inside the next parenthesis
          L = "@f(mi(";

          left = "jump_view_left";
          right = "jump_view_right";
          up = "jump_view_up";
          down = "jump_view_down";

          # "~" = "switch_case"
          # u = "switch_to_lowercase";
          # U = "switch_to_uppercase";
        };
        # "[" = builtins.mapAttrs (_: command: left-bracket command) {
        #   b = ":buffer-previous";
        #   d = "goto_prev_diag";
        #   D = "goto_first_diag";
        #   g = "goto_prev_change";
        #   G = "goto_first_change";
        #   f = "goto_prev_function";
        #   t = "goto_prev_class";
        #   a = "goto_prev_parameter";
        #   c = "goto_prev_comment";
        #   e = "goto_prev_entry";
        #   T = "goto_prev_test";
        #   p = "goto_prev_paragraph";
        # };
        # "]" = builtins.mapAttrs (_: command: right-bracket command) {
        #   b = ":buffer-next";
        #   d = "goto_next_diag";
        #   D = "goto_last_diag";
        #   g = "goto_next_change";
        #   G = "goto_last_change";
        #   f = "goto_next_function";
        #   t = "goto_next_class";
        #   a = "goto_next_parameter";
        #   c = "goto_next_comment";
        #   e = "goto_next_entry";
        #   T = "goto_next_test";
        #   p = "goto_next_paragraph";
        # };
      };
      keys.select = {
        y = [ "yank_joined" ];
        # A-x = "extend_to_line_bounds";
        X = [
          "extend_line_up"
          "extend_to_line_bounds"
        ];
        # g = {
        #   u = "switch_to_lowercase";
        #   U = "switch_to_uppercase";
        # };
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

      language-server.sonarlint-ls = {
        command = "${lib.getExe pkgs.sonarlint-ls}";
      };

      language-server.rust-analyzer = {
        config = {

          check.command = "clippy";
          assist = {
            emitMustUse = true;

          };
          diagnostics = {
            experimental.enable = true;
            styleLints.enable = true;
          };
          imports = {
            preferPrelude = true;
          };
          inlayHints = {
            bindingModeHints.enable = false;
            closingBraceHints.minLines = 10;
            closureReturnTypeHints.enable = "with_block";
            discriminantHints.enable = "fieldless";
            lifetimeElisionHints.enable = "skip_trivial";
            typeHints.hideClosureInitialization = false;
          };
          semanticHighlighting = {
            operator.specialization.enable = true;
          };
        };
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
            file-types = [
              "qmd" # to quarto langauge yet
              "md"
              "livemd"
              "markdown"
              "mdx"
              "mkd"
              "mkdn"
              "mdwn"
              "mdown"
              "markdn"
              "mdtxt"
              "mdtext"
              "workbook"
              { glob = "PULLREQ_EDITMSG"; }
            ];
            formatter = {
              command = "${pkgs.mdformat}/bin/mdformat";
              args = [ "-" ];
            };
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
            # formatter = {
            #   command = "${pkgs.dprint}/bin/dprint";
            #   args = [
            #     "fmt"
            #     "--stdin"
            #     "css"
            #   ];
            # };
            language-servers = [
              "vscode-css-language-server"
              "dprint"
            ];
          }
          {
            name = "fish";
            auto-format = true;
            formatter.command = "${pkgs.fish}/bin/fish_indent";
            file-types = [ "fish" ];
          }
          {
            name = "java";
            auto-format = true;
            language-servers = [
              "jdtls"
              "sonarlint-ls" # TODO: test it works
            ];
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
            # language-servers = [ "nls" ];
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
            language-servers = [ "nu-lsp" ];
            # FIXME: fucks up the text
            # formatter.command = "${pkgs.nufmt}/bin/nufmt";
            # formatter.args = [ "--stdin" ];
            inherit indent;
          }
          # {
          #   name = "python";
          #   language-servers = ["basedpyright"];
          # }
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
          #   name = "d2";
          #   file-types = [ "d2" ];
          #   source.git = "https://git.pleshevski.ru/pleshevskiy/tree-sitter-d2";
          #   source.rev = "main";
          # }
          # {
          #   name = "kitty-conf";
          #   source.git = "https://github.com/clo4/tree-sitter-kitty-conf";
          #   source.rev = "main";
          # }
        ];
    };
  };

  # TODO: test this actually runs on a rebuild
  home.activation.fetch-and-build-grammars =
    let
      hx = "${config.programs.helix.package}/bin/hx";
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ]
      # bash
      ''
        verboseEcho "Fetching tree-sitter grammars"
        run ${hx} --grammar fetch
        verboseEcho "Building tree-sitter grammars"
        run ${hx} --grammar build
      '';

  xdg.configFile."helix/runtime/queries/roc".source = "${tree-sitter-roc}/queries";
}
