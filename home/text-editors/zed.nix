{ lib, pkgs, ... }:
{

  programs.zed-editor.enable = false;
  programs.zed-editor.package = pkgs.zed-editor;
  # programs.zed-editor.package = pkgs.zed-editor-fhs;
  # programs.zed-editor.extensions = [
  #   "nix"
  #   "toml"
  #   "dockerfile"
  #   "docker-compose"
  #   "html"
  #   "catppuccin"
  #   "sql"
  #   "pest"
  #   "d2"
  #   "roc"
  #   "java"
  #   "fish"
  # ];
  # programs.zed-editor.userSettings = {
  #   # theme = "Catppuccin Mocha";
  #   theme = lib.mkForce "Gruvbox Dark";
  #   base_keymap = "VSCode";
  #   features.copilot = false;
  #   telemetry.metrics = false;
  #   telemetry.diagnostics = false;
  #   features.inline_completion_provider = "supermaven";
  #   show_inline_completions = true;
  #   ui_font_size = 20;
  #   buffer_font_size = 14;
  #   buffer_font_family = "JetBrainsMono Nerd Font Mono";
  #   vim_mode = false;
  #   auto_save = "on_window_change";
  #   load_direnv = "direct";
  #   inlay_hints.enabled = true;
  #   preview_tabs = {
  #     enabled = true;
  #     enable_preview_from_file_finder = true;
  #     enable_preview_from_code_navigation = true;
  #   };

  #   git = {
  #     inline_blame = {
  #       enabled = true;
  #       show_commit_summary = true;
  #       delay_ms = 500;
  #     };
  #   };

  #   file_finder.modal_width = "medium";
  #   autoscroll_on_clicks = true;
  #   inline_completions_disabled_in = [ "string" ];
  #   lsp = {
  #     nixd = { };
  #   };

  #   languages = {
  #     Python = {
  #       language_servers = [ "${lib.getExe pkgs.basedpyright}" ];
  #     };
  #     Nix = {
  #       tab_size = 4;
  #       language_servers = [
  #         "nixd"
  #         "!nil"
  #       ];
  #     };
  #   };
  # };

  # programs.zed-editor.userKeymaps =

  #   let

  #     mapping = context: binding: action: {
  #       inherit context;
  #       bindings.${binding} = action;
  #     };
  #     workspace = mapping "Workspace";
  #     terminal = mapping "Terminal";
  #     editor = mapping "Editor";
  #     pane = mapping "Pane";
  #   in
  #   [
  #     # "ctrl-alt--": "pane::GoBack",
  #     # "ctrl-alt-_": "pane::GoForward",
  #     (pane "alt-left" "pane::GoBack")
  #     (pane "alt-right" "pane::GoForward")
  #     (workspace "ctrl-shift-t" "workspace::NewTerminal")
  #     (terminal "ctrl-n" [
  #       "terminal::SendKeystroke"
  #       "ctrl-n"
  #     ])

  #     # {
  #     #   "context": "Terminal",
  #     #   "bindings": {
  #     #     "ctrl-n": ["terminal::SendKeystroke", "ctrl-n"]
  #     #   }
  #     # }

  #     # {
  #     #   context = "Workspace";
  #     #   bindings = {
  #     #     ctrl-shift-t = "workspace::NewTerminal";
  #     #   };
  #     # }
  #   ];
}
