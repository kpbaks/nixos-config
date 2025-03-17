{ config, pkgs, ... }:
let

  # TODO: upstream to helix
  tree-sitter-roc = pkgs.fetchFromGitHub {
    owner = "faldor20";
    repo = "tree-sitter-roc";
    rev = "ef46edd0c03ea30a22f7e92bc68628fb7231dc8a";
    hash = "sha256-H76cnMlBT1Z/9WXAdoVslImkyy38uCqum9qEnH+Ics8=";
  };
in
{
  programs.helix.extraPackages = [ pkgs.nil ];
  programs.helix.languages = {

    language-server.clangd = {
      # command = "${pkgs.clang-tools}/bin/clangd";
      args = [
        "--completion-style"
        "detailed"
        "--pretty"
        "--all-scopes-completion"
        "--clang-tidy"
      ];
    };
    # TODO: upstream
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
      command = "${config.programs.nushell.package}/bin/nu";
      args = [ "--lsp" ];
      language-id = "nu";
    };
    # language-server.ruff-lsp = {
    #   command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
    #   language-id = "python";
    # };
    # language-server.dprint = {
    #   command = "${pkgs.dprint}/bin/dprint";
    #   args = [ "lsp" ];
    # };

    # TODO: get to work outside of vscode
    # language-server.sonarlint-ls = {
    #   command = "${lib.getExe pkgs.sonarlint-ls}";
    # };

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
          formatter.command = "${config.programs.fish.package}/bin/fish_indent";
        }
        {
          name = "java";
          auto-format = true;
          language-servers = [
            "jdtls"
            # "sonarlint-ls" # TODO: test it works
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
        # {
        #   name = "lua";
        #   auto-format = true;
        #   formatter.command = "${pkgs.stylua}/bin/stylua";
        # }
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
          language-servers = [ "nil" ];
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
        {
          name = "python";
          language-servers = [
            "basedpyright"
            "ruff"
            "typos-lsp"
            "ast-grep"
          ];
        }
        {
          name = "toml";
          auto-format = true;
          # formatter = {
          #   command = "${pkgs.taplo}/bin/taplo";
          #   args = [
          #     "format"
          #     "-"
          #   ];
          # };
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
        {
          name = "sed";
          scope = "source.sed";
          file-types = [ "sed" ];
          comment-token = "#";
        }

        # [[grammar]]
        # name = "sed"
        # source = { git = "https://github.com/mskelton/tree-sitter-sed", rev = "e13f8bccd4e6bc190fa34f3df8b2d576a41ff04d" }

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
    grammar = [
      {
        name = "sed";
        source = {
          git = "https://github.com/mskelton/tree-sitter-sed";
          rev = "e13f8bccd4e6bc190fa34f3df8b2d576a41ff04d";
        };
      }
    ];
  };

  xdg.configFile."helix/runtime/queries/roc".source = "${tree-sitter-roc}/queries";
}
