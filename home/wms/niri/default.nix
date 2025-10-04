{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  laptop-screen = "eDP-1";
in
{
  imports = [
    inputs.niri.homeModules.niri
    ./scripts
    ./window-rules.nix
    ./layer-rules.nix
    ./binds.nix
    ./outputs.nix
    ./overview.nix
    ./event-stream-handler.nix
    ./niriswitcher.nix
  ];

  # `niri` does not have built-in Xwayland support
  home.packages =
    with pkgs;
    let
      title-case-word =
        word:
        let
          inherit (builtins) substring stringLength;
          firstchar = substring 0 1 word;
          rest = substring 1 (stringLength word - 1) word;
        in
        lib.strings.toUpper firstchar + lib.strings.toLower rest;

      # catppuccin-cursor =
      #   let
      #     variant = "${config.catppuccin.flavor}${title-case-word config.catppuccin.accent}";
      #   in
      #   catppuccin-cursors.${variant};

    in
    [
      # cage
      # xwayland-run
      # FIXME: crashes when starting as a systemd service
      # xwayland-satellite
      # wlrctl
      # wlr-which-key
      # wlr-randr
      # wlr-layout-ui
      # pkgs.catppuccin-fcitx5
      # catppuccin-cursor
      # pkgs.catppuccin-cursors.${config.}
      # xwayland-satellite-nixpkgs
      # xwayland-satellite-unstable
    ];

  # TODO: see if this is possible in home-manager
  # https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup
  # xdg.configFile."systemd/user/niri.service.wants";
  programs.niri.enable = true;
  # FIXME: this is a hack, it should use the one in ny nixos configuration
  programs.niri.package = pkgs.niri-unstable;
  # programs.niri.package = osConfig.programs.niri.package;
  programs.niri.settings.prefer-no-csd = true;
  programs.niri.settings.screenshot-path = "${config.home.homeDirectory}/Pictures/screenshots/screenshot-%Y-%m-%d %H-%M-%S.png";
  programs.niri.settings.hotkey-overlay.skip-at-startup = true;
  programs.niri.settings.workspaces = {
    main = {
      # open-on-output = "eDP-1"; # laptop screen
    };
    mail = {
      open-on-output = laptop-screen;
    };
    chat = { };
    development = { };
    gaming = { };
  };

  programs.niri.settings = {
    input.focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "5%";
    };
    # My Wacom Intuos tablet
    # tablet = {
    #   enable = true;
    #   left-handed = true;
    #   # // calibration-matrix 1.0 0.0 0.0 0.0 1.0 0.0
    # };
  };

  programs.niri.settings.input.touchpad.dwt = true; # "disable when typing"
  programs.niri.settings.input.warp-mouse-to-focus.enable = true;
  programs.niri.settings.input.keyboard.track-layout = "window";

  programs.niri.settings.input.mouse.left-handed = false;

  programs.niri.settings.environment = {
    # DISPLAY = null;
    DISPLAY = null;
    MOZ_ENABLE_WAYLAND = "1";

    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # For Electron >= 28.0
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # [tag:set_XDG_CURRENT_DESKTOP_to_niri]
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
  # programs.niri.settings.cursor = {
  #   # TODO: figure out if this cursor pack is packaged in nixpkgs, and if it is
  #   # then depend on it properly.
  #   # theme = "breeze_cursors";
  #   theme = "catppuccin_cursors";
  #   size = 32;
  # };
  programs.niri.settings.input.workspace-auto-back-and-forth = true;
  programs.niri.settings.input.keyboard.xkb = {
    layout = "us,dk";
    # variant = "colemak_dh_ortho"; # FIXME: xkbcommon does not regognize this value

    # options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
    options = "compose:ralt,ctrl:nocaps";
  };

  programs.niri.settings.layout = {
    gaps = 8; # px
    # struts = {
    #   left = 16;
    #   right = 16;
    #   top = 16;
    #   bottom = 16;
    # };
    center-focused-column = "on-overflow";
    default-column-display = "tabbed";
    empty-workspace-above-first = true;
    always-center-single-column = true;
    # center-focused-column = "never";
    # center-focused-column = "always";
    preset-column-widths = [
      { proportion = 1.0 / 3.0; }
      { proportion = 1.0 / 2.0; }
      { proportion = 2.0 / 3.0; }
    ];
    # default-column-width = {proportion = 1.0 / 3.0;};
    default-column-width.proportion = 1.0 / 2.0;
    # default-column-width.proportion = 2.0 / 3.0;
    # default-column-width = {proportion = 1.0;};
    focus-ring = {
      enable = true;
      width = 4;
      # active.color = lavender.hex;
      # inactive.color = flamingo.hex;
      # active.gradient = {
      #   from = "#80c8ff";
      #   to = "#d3549a";
      #   angle = 45;
      # };
    };
  };

  programs.niri.settings.spawn-at-startup =
    map (s: { command = pkgs.lib.strings.splitString " " s; })
      [
        (lib.getExe config.default-application.terminal)
        (lib.getExe config.default-application.browser)
        (lib.getExe config.programs.thunderbird.package)
        (lib.getExe config.programs.vesktop.package)
        (lib.getExe pkgs.telegram-desktop)
        # TODO: does not show-up
        # "${pkgs.telegram-desktop}/bin/telegram-desktop -startintray"
        # "ironbar"
        # "${pkgs.swww}/bin/swww-daemon"
        # "${pkgs.swaybg}/bin/swaybg -i /home/kpbaks/Pictures/wallpapers/spacehawks.png"
        # TODO: run with systemd
        # "${pkgs.swaybg}/bin/swaybg -i /home/kpbaks/Pictures/wallpapers/helix-logo.png"
        # "${pkgs.copyq}/bin/copyq"
        # "${pkgs.eww}/bin/eww daemon"
        # "${pkgs.birdtray}/bin/birdtray"
        # TODO: run with systemd
        # "${pkgs.wluma}/bin/wluma"
        # FIXME: does not work
        # "${pkgs.obs-studio}/bin/obs --minimize-to-tray"
      ];

  # TODO: experiment with this
  # programs.niri.settings.animations.shaders = {
  #   window-resize = builtins.readFile ./shaders/window-resize.glsl;
  #   window-open = null;
  #   window-close = null;
  # };

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
  # services.kanshi = {
  #   enable = config.programs.niri.enable;
  #   # TODO: does this target exist?
  #   systemdTarget = "niri-session.target";
  #   settings = [
  #     {
  #       profile.name = "undocked";
  #       profile.outputs = [
  #         {
  #           criteria = "eDP-1";
  #           scale = 1.0;
  #           status = "enable";
  #         }
  #       ];
  #     }
  #   ];
  # };

  # systemd.user.services.niri-notify-when-keyboard-layout-changes = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.birdtray}/bin/birdtray";
  # };

  xdg.desktopEntries = {
    power-off-monitors = {
      name = "niri - Power off monitors";
      exec = lib.getExe (
        pkgs.writeShellScriptBin "niri-power-off-monitors" ''${config.programs.niri.package}/bin/niri msg action power-off-monitors''
      );
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
    open-screenshots-dir = {
      name = "niri - Open screenshots directory";
      exec = lib.getExe (
        pkgs.writeShellScriptBin "niri-open-screenshots-dir" ''${pkgs.libnotify}/bin/xdg-open $(dirname ${config.programs.niri.settings.screenshot-path})''
      );
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
  };
}
