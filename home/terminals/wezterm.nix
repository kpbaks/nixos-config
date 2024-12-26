{ config, lib, ... }:
let
  title-case-word =
    word:
    let
      inherit (builtins) substring stringLength;
      firstchar = substring 0 1 word;
      rest = substring 1 (stringLength word - 1) word;
    in
    lib.strings.toUpper firstchar + lib.strings.toLower rest;
  # wezterm comes with support for catppuccin themes. Although they are named
  # "Catppuccin <flavor>" where <flavor> := "Latte" | "Macchiato" | "Frappe" | "Mocha"
  # `config.catppuccin.flavor` is lowercase, so we have to titlecase it
  # ref: https://github.com/catppuccin/wezterm
  catppuccin_color_scheme = ''"Catppuccin ${title-case-word config.catppuccin.flavor}"'';
  # catppuccin_colors_lua = lib.pipe config.flavor [
  #   builtins.attrValues
  #   (map (v: ''local "${v.hex}"''))
  # tt

in
# ]
{

  programs.wezterm = {
    enable = true;
    extraConfig =
      # lua

      ''
        local config = wezterm.config_builder()
        -- NOTE: fixes this issue
        -- https://github.com/NixOS/nixpkgs/issues/336069
        config.front_end = "WebGpu"

        -- Enable WebGpu if there is an integrated GPU available with Vulkan drivers
        -- for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
        --   if gpu.backend == 'Vulkan' and gpu.device_type == 'IntegratedGpu' then
        --     config.webgpu_preferred_adapter = gpu
        --     config.front_end = 'WebGpu'
        --     break
        --   end
        -- end

        -- TODO: determine this when building home-manager config instead
        -- if wezterm.target_triple:find("linux") ~= nil then
          config.enable_wayland = true
        -- end

        config.font_size = 12.0
        config.enable_scroll_bar = true
        config.automatically_reload_config = true
        config.scrollback_lines = 5000
        config.status_update_interval = 1000
        config.window_decorations = 'RESIZE'

        -- Then, activate with CTRL + ALT + P for presentation mode, or CTRL + ALT + SHIFT + P for fullscreen presentation.
        wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(config)

        wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm").apply_to_config(config)

        local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
        bar.apply_to_config(config)
        --bar.apply_to_config(
        --  config,
        --  {
        --    position = "bottom",
        --    padding = {
        --      left = 1,
        --      right = 1,
        --    },
        --    separator = {
        --      space = 1,
        --      left_icon = wez.nerdfonts.fa_long_arrow_right,
        --      right_icon = wez.nerdfonts.fa_long_arrow_left,
        --      field_icon = wez.nerdfonts.indent_line,
        --    },

        --    colors = {
        --      tab_bar = {
        --        background = "${config.flavor.crust.hex}",
        --      }
        --    }
        --  }
        --)



        -- Hide scroll bar in alternate screen e.g. hx or htop
        -- ref: https://github.com/wez/wezterm/issues/4331#issuecomment-1743703985
        wezterm.on("update-status", function(window, pane)
          local overrides = window:get_config_overrides() or {}
          if not overrides.colors then
            overrides.colors = {}
          end
          if pane:is_alt_screen_active() then
            overrides.colors.scrollbar_thumb = "transparent"
          else
            overrides.colors.scrollbar_thumb = nil
          end
          window:set_config_overrides(overrides)
        end)

        function scheme_for_appearance(appearance)
          if appearance:find "Dark" then
            return "Catppuccin Mocha"
          else
            return "Catppuccin Latte"
          end
        end

        config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
        -- config.color_scheme = ${catppuccin_color_scheme}

        local act = wezterm.action

        config.keys = {
          {
            key = "F11",
            mods = "",
            action = wezterm.action.ToggleFullScreen,
          },
          {
            key = "P",
            mods = "CTRL",
            action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|TABS|WORKSPACES" },
          },
          # {
          #   key = "f1",
          #   mods = "",
          #   action = wezterm.action.ShowLauncherArgs,
          # },
        }

        config.mouse_bindings = {
          -- Scrolling up while holding CTRL increases the font size
          {
            event = { Down = { streak = 1, button = { WheelUp = 1 } } },
            mods = 'CTRL',
            action = act.IncreaseFontSize,
          },

          -- Scrolling down while holding CTRL decreases the font size
          {
            event = { Down = { streak = 1, button = { WheelDown = 1 } } },
            mods = 'CTRL',
            action = act.DecreaseFontSize,
          },
            -- Bind 'Up' event of CTRL-Click to open hyperlinks
          {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor,
          },
          -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
          {
            event = { Down = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.Nop,
          },
        }

        config.native_macos_fullscreen_mode = false

        config.command_palette_fg_color = "${config.flavor.lavender.hex}"
        config.command_palette_font_size = 14.0

        return config
      '';
  };

  programs.nushell.extraConfig = # nu
    ''
      # def "wezterm cli list-clients" [--format: string = "json"] {
      def "wezterm cli list-clients" [] {
        ${config.programs.wezterm.package}/bin/wezterm cli list-clients --format=json
        | from json
        | update connection_elapsed { |row|
          let d = $row.connection_elapsed
          let secs = $d.secs | into duration --unit sec
          let nanos = $d.nanos | into duration --unit ns
          $secs + $nanos
        }
        | update idle_time { |row|
          let d = $row.idle_time
          let secs = $d.secs | into duration --unit sec
          let nanos = $d.nanos | into duration --unit ns
          $secs + $nanos
        }
      }
    '';
}
