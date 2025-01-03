{ lib, ... }:
{

  programs.zed-editor.enable = true;
  programs.zed-editor.extensions = [
    "nix"
    "toml"
    "dockerfile"
    "docker-compose"
    "html"
    "catppuccin"
    "sql"
    "pest"
    "d2"
    "roc"
    "java"
  ];
  programs.zed-editor.userSettings = {
    # theme = "Catppuccin Mocha";
    theme = lib.mkForce "Gruvbox Dark";
    base_keymap = "VSCode";
    features.copilot = false;
    telemetry.metrics = false;
    telemetry.diagnostics = false;
    features.inline_completion_provider = "supermaven";
    show_inline_completions = true;
    ui_font_size = 20;
    buffer_font_size = 14;
    buffer_font_family = "JetBrainsMono Nerd Font Mono";
    vim_mode = false;
    auto_save = "on_window_change";
    load_direnv = "direct";
    inlay_hints.enabled = true;
    preview_tabs = {
      enabled = true;
      enable_preview_from_file_finder = true;
      enable_preview_from_code_navigation = true;
    };
    file_finder.modal_width = "medium";
  };

  programs.zed-editor.userKeymaps = [
    {
      context = "Workspace";
      bindings = {
        ctrl-shift-t = "workspace::NewTerminal";
      };
    }
  ];
}
