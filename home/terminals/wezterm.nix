{ ... }:
{

  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
        -- Pull in the wezterm API
        -- local wezterm = require "wezterm"

        -- This will hold the configuration.
        local config = wezterm.config_builder()
        -- NOTE: fixes this issue
        -- https://github.com/NixOS/nixpkgs/issues/336069
        config.front_end = "WebGpu"
        config.enable_wayland = false

        return config
      '';
  };
}
