# TODO: deduplicate keys to work in normal and select mode like in: https://github.com/NikitaRevenco/dotfiles/blob/main/helix.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    ./yazi-picker.nix
    ./languages.nix
    ./keys.nix
    ./themes.nix
    # ./hx-wrapper.nix
    ./fetch-and-build-grammars-on-build.nix
    ./snippets

    # inputs.crates-lsp.homeModules.${pkgs.system}.default
  ];
  programs.helix = {
    enable = true;
    defaultEditor = lib.mkForce true;
    extraPackages = with pkgs; [
      libclang
      gcc

      #   bash-language-server
      #   shellcheck
      #   shfmt
      #   shellharden
      #   # jq-lsp
      #   marksman
      #   taplo
      #   typos
      #   simple-completion-language-server
      #   # pkgs.vscode-langservers-extracted
      #   # dprint
      #   # python3Packages.python-lsp-server
      #   # python3Packages.python-lsp-ruff

      #   # lua-language-server
      #   # sonarlint-ls

      #   # stylua
      #   # selene
      #   harper
      #   # scls
      #   # nls
      #   mdformat
      #   python313Packages.mdformat-tables
    ];

    ignores = [
      ".build/"
      "build/"
      "target/"
      "typings/" # Python specific
      ".direnv/"
    ];

    settings = {
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
        idle-timeout = 250; # ms
        completion-timeout = 5; # ims
        auto-info = true;
        auto-format = true;
        undercurl = true;

        trim-trailing-whitespace = true;
        trim-final-newlines = true;

        mouse = true;
        preview-completion-insert = true;
        color-modes = true;
        # popup-border = "all";
        popup-border = "none";
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
          hidden = true;
          git-ignore = true; # TODO: create a feature to show ignored but have them dimmed out
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

          mode.normal = "NORMAL 😄";
          mode.insert = "INSERT 😤";
          mode.select = "SELECT 🥸";
        };
        search = {
          smart-case = false;
          wrap-around = true;
        };
      };

    };
  };

  # programs.fish.shellAbbrs.hx.function = "_abbr_hx";
  # programs.fish.functions._abbr_hx.body =
  #   # fish
  #   ''
  #     # TODO: check beforehand that HELIX_RUNTIME is not set
  #     if ${config.programs.git.package}/bin/git rev-parse --show-toplevel | read toplevel
  #         # TODO to make expansion shorter use relative path instead of abs
  #         if test (path basename $toplevel) = helix -a -e $toplevel/runtime
  #             set -l runtime
  #             if test $PWD = $toplevel
  #               set runtime ./runtime
  #             else
  #               set runtime $toplevel/runtime
  #             end
  #             printf "HELIX_RUNTIME=%s " $runtime
  #         end
  #     end

  #     # TODO: estimate the file i am most likely to want to edit
  #     echo hx
  #   '';
}
