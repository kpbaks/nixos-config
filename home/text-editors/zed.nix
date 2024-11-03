{
  config,
  lib,
  pkgs,
  ...
}:
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
  ];
  programs.zed-editor.userSettings = {
    theme = "Catppuccin Mocha";
    features.copilot = false;
    telemetry.metrics = false;
    ui_font_size = 16;
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
