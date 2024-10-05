{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    ./scripts
    ./window-rules.nix
    ./binds.nix
  ];

  # `niri` does not have built-in Xwayland support
  home.packages = with pkgs; [
    cage
    xwayland-run
    # FIXME: crashes when starting as a systemd service
    xwayland-satellite
  ];

  # TODO: see if this is possible in home-manager
  # https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup
  # xdg.configFile."systemd/user/niri.service.wants";
  programs.niri.enable = true;
  programs.niri.settings.prefer-no-csd = true;
  programs.niri.settings.screenshot-path = "${config.home.homeDirectory}/Pictures/screenshots/screenshot-%Y-%m-%d %H-%M-%S.png";
  programs.niri.settings.hotkey-overlay.skip-at-startup = false;
  programs.niri.settings.workspaces."main" = {
    open-on-output = "eDP-1"; # laptop screen
  };

  programs.niri.settings.input.focus-follows-mouse = {
    enable = true;
    max-scroll-amount = "5%";
  };

  programs.niri.settings.input.touchpad.dwt = true; # "disable when typing"
  programs.niri.settings.input.warp-mouse-to-focus = true;
  programs.niri.settings.input.keyboard.track-layout = "window";

  programs.niri.settings.input.mouse.left-handed = false;

  programs.niri.settings.environment = {
    # DISPLAY = null;
    DISPLAY = ":0";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
  programs.niri.settings.cursor = {
    # TODO: figure out if this cursor pack is packaged in nixpkgs, and if it is
    # then depend on it properly.
    theme = "breeze_cursors";
    size = 32;
  };
  programs.niri.settings.input.workspace-auto-back-and-forth = true;
  programs.niri.settings.input.keyboard.xkb = {
    layout = "us,dk";
    variant = "colemak_dh_ortho"; # FIXME: xkbcommon does not regognize this value

    # options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
    options = "compose:ralt,ctrl:nocaps";
  };

  programs.niri.settings.layout = {
    gaps = 12; # px
    struts = {
      left = 0;
      right = 0;
      top = 0;
      bottom = 0;
    };
    center-focused-column = "on-overflow";
    # center-focused-column = "never";
    # center-focused-column = "always";
    preset-column-widths = [
      { proportion = 1.0 / 3.0; }
      { proportion = 1.0 / 2.0; }
      { proportion = 2.0 / 3.0; }
    ];
    # default-column-width = {proportion = 1.0 / 3.0;};
    # default-column-width.proportion = 1.0 / 2.0;
    default-column-width.proportion = 2.0 / 3.0;
    # default-column-width = {proportion = 1.0;};
    focus-ring = with config.flavor; {
      enable = true;
      width = 4;
      active.color = lavender.hex;
      inactive.color = flamingo.hex;
      # active.gradient = {
      #   from = "#80c8ff";
      #   to = "#d3549a";
      #   angle = 45;
      # };
    };
  };

  programs.niri.settings.outputs = {
    # Laptop screen
    "eDP-1" = {
      # TODO: open issue or submit pr to `niri` to add `niri msg output <output> background-color <color>` to the cli
      background-color = config.flavor.surface2.hex;
      scale = 1.0;
      position.x = 0;
      position.y = 0;
    };
    "Acer Technologies K272HUL T6AEE0058502" = {
      background-color = config.flavor.surface1.hex;
      scale = 1.0;
      transform.rotation = 0;
      variable-refresh-rate = "on-demand";
      position.x = 0;
      position.y = -1600;
    };
  };

  programs.niri.settings.spawn-at-startup =
    map (s: { command = pkgs.lib.strings.splitString " " s; })
      [
        # "ironbar"
        # "${pkgs.swww}/bin/swww-daemon"
        "${pkgs.copyq}/bin/copyq"
        "${pkgs.eww}/bin/eww daemon"
        # "${pkgs.birdtray}/bin/birdtray"
        "${pkgs.wluma}/bin/wluma"
        # TODO: does not show-up
        # "${pkgs.telegram-desktop}/bin/telegram-desktop -startintray"
        # FIXME: does not work
        # "${pkgs.obs-studio}/bin/obs --minimize-to-tray"
      ];

  programs.niri.settings.animations.screenshot-ui-open = {
    easing = {
      curve = "ease-out-quad";
      duration-ms = 200;
    };
  };
  programs.niri.settings.animations.workspace-switch = {
    spring = {
      damping-ratio = 1.0;
      epsilon = 1.0e-4;
      stiffness = 1000;
    };
  };

  # TODO: experiment with this
  programs.niri.settings.animations.shaders = {
    window-resize = builtins.readFile ./shaders/window-resize.glsl;
    window-open = null;
    window-close = null;
  };

  # FIXME: does not load correctly
  # TODO: check it works correctly
  # TODO: do we need to load it manually or does `niri-flake` do it?
  # Used for Xwayland integration in `niri`
  # Copied from: https://github.com/Supreeeme/xwayland-satellite/blob/main/resources/xwayland-satellite.service
  # systemd.user.services.xwayland-satellite = {
  #   Unit = {
  #     Description = "Xwayland outside your Wayland";
  #     BindsTo = "graphical-session.target";
  #     PartOf = "graphical-session.target";
  #     After = "graphical-session.target";
  #     Requisite = "graphical-session.target";
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service = {
  #     Type = "notify";
  #     NotifyAccess = "all";
  #     ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
  #     StandardOutput = "journal";
  #   };
  # };

  # systemd.user.services.swww-daemon = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${inputs.swww.packages.${pkgs.system}.swww}/bin/swww-daemon";
  # };

  # systemd.user.services.copyq = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.copyq}/bin/copyq";
  # };

  # systemd.user.services.eww-daemon = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.eww}/bin/eww daemon";
  # };

  # https://haseebmajid.dev/posts/2023-07-25-nixos-kanshi-and-hyprland/
  # "eDP-1" is laptop screen
  services.kanshi = {
    enable = config.programs.niri.enable;
    # TODO: does this target exist?
    systemdTarget = "niri-session.target";
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
    ];
  };

  # systemd.user.services.niri-notify-when-keyboard-layout-changes = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.birdtray}/bin/birdtray";
  # };
}
