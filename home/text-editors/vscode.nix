{ pkgs, inputs, ... }:
{

  # TODO: convert settings to this
  programs.vscode =
    let
      # inherit (pkgs) vscode-with-extensions;
      extensions = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = false;
      # package = pkgs.vscode;
      # package = pkgs.vscode.fhs;
      # TODO: override pkgs.vscodium to append flag --disable-workspace-trust
      package = pkgs.vscodium.fhs;
      # package = pkgs.vscodium;
      profiles.default.enableExtensionUpdateCheck = true;
      profiles.default.enableUpdateCheck = true;
      # extensions = with pkgs.vscode-extensions; [
      profiles.default.extensions = with extensions.vscode-marketplace; [

        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime
        # github.copilot
        # github.copilot-chat
        # https://github.com/nix-community/vscode-nix-ide
        # llvm-vs-code-extensions.vscode-clangd
        # tiehuis.zig
        # avaloniateam.vscode-avalonia
        # decodetalkers.neocmake-lsp-vscode
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        cheshirekow.cmake-format
        # github.classroom
        gleam.gleam
        jnoortheen.nix-ide
        mguellsegarra.highlight-on-copy
        ms-python.python
        ms-toolsai.jupyter
        # ms-vscode.cpptools
        # ms-vsliveshare.vsliveshare
        # nvarner.typst-lsp
        rust-lang.rust-analyzer
        supermaven.supermaven
        tamasfe.even-better-toml
        tomoki1207.pdf
        twxs.cmake
        usernamehw.errorlens
        yzhang.markdown-all-in-one

        # zxh404.vscode-proto3
        # tabnine.tabnine-vscode
      ];
      profiles.default.userSettings =
        let
        in
        # TODO: get to work
        # flatten-attrs = attrs: prefix:
        #   let inherit (builtins) attrNames concatStringSep isAttrs;
        #   flatten = name: value:
        #     if isAttrs value then
        #       flatten-attrs value (concatStringSep "." [prefix name])
        #     else
        #       { (concatStringsSep "." [prefix name]) = value; };
        #   in builtins.foldl' (acc: name: acc // flatten name (attrs.${name})) {} (attrNames attrs);
        {
          "editor.tabSize" = 4;
          "editor.fontSize" = 14;
          "editor.cursorStyle" = "line";
          # "editor.fontFamily" = mapjoin ", " (font: "'${font}'") [
          #   "Iosevka Nerd Font Mono"
          #   "JetBrainsMono Nerd Font Mono"
          #   "Droid Sans Mono"
          #   "monospace"
          # ];

          "editor.fontLigatures" = true;

          "editor.formatOnSave" = true;
          "editor.minimap.autohide" = false;
          "editor.minimap.enabled" = true;
          "editor.minimap.side" = "right";
          "editor.wordWrap" = "on";
          "editor.renderWhitespace" = "trailing";
          "editor.mouseWheelZoom" = true;
          "editor.guides.bracketPairs" = true;
          "editor.inlayHints.padding" = true;
          "editor.inlayHints.enabled" = "offUnlessPressed";
          "editor.lineHeight" = 1.25;
          "editor.acceptSuggestionOnEnter" = "smart";
          "editor.suggest.preview" = true;
          "editor.suggest.localityBonus" = true;
          # "editor.suggest.showToolbar" = "always";
          "editor.tabCompletion" = "on";
          "explorer.fileNesting.enabled" = true;
          "files.autoSave" = "onWindowChange";
          "files.enableTrash" = true;
          "files.trimFinalNewlines" = true;
          "files.eol" = "\n";
          "files.insertFinalNewline" = true;
          "files.trimTrailingWhitespace" = true;

          "workbench.commandPalette.experimental.suggestCommands" = true;
          "workbench.commandPalette.preserveInput" = false;
          "workbench.list.smoothScrolling" = true;

          # "workbench.colorTheme" = "Default Dark Modern";

          "workbench.sideBar.location" = "left";
          "workbench.tips.enabled" = true;
          "workbench.tree.indent" = 16;
          "breadcrumbs.enabled" = true;
          "window.titleBarStyle" = "custom";
          "window.autoDetectColorScheme" = true;
          "window.confirmBeforeClose" = "keyboardOnly";
          "telemetry.telemetryLevel" = "off";
          "window.zoomLevel" = 0;
          "github.copilot.enable" = {
            "*" = true;
          };

          "[nix]"."editor.tabSize" = 2;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
          "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          "tabnine.experimentalAutoImports" = true;
          "tabnine.debounceMilliseconds" = 1000;
          "jupyter.executionAnalysis.enabled" = true;
          "jupyter.themeMatplotlibPlots" = false;
          "notebook.formatOnCellExecution" = true;
          "notebook.formatOnSave.enabled" = true;
          "notebook.insertFinalNewline" = true;
          "notebook.lineNumbers" = "on";
          "notebook.output.minimalErrorRendering" = false;
          "jupyter.askForKernelRestart" = false;

          "rust-analyzer.check.command" = "clippy";
          "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
          "[rust]"."editor.formatOnSave" = true;
          "workbench.preferredLightColorTheme" = "Catppuccin Latte";
          "security.workspace.trust.enabled" = false;
          # "workbench.colorTheme": "Default Dark Modern",
        };
      profiles.default.keybindings =
        let
          ctrl = key: "ctrl+" + key;
          alt = key: "alt+" + key;
          # ctrl-alt = key: "ctrl+alt+" + key;
          ctrl-shift = key: "ctrl+shift+" + key;
          keybind = key: command: { inherit key command; };
        in
        [
          (keybind (ctrl "p") "workbench.action.quickOpen")
          (keybind (ctrl "h") "workbench.action.navigateLeft")
          (keybind (ctrl "l") "workbench.action.navigateRight")
          (keybind (alt "left") "workbench.action.navigateBack")
          (keybind (alt "right") "workbench.action.navigateForward")
          {
            key = ctrl-shift "right";
            command = "editor.action.inlineSuggest.acceptNextLine";
            when = "inlineSuggestionVisible && !editorReadonly";
          }
        ];
    };
}
