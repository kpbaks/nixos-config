{
  config,
  osConfig,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules
    ./programs
    ./services
    ./bars
    ./browsers
    ./custom-modules
    ./launchers
    ./notification-daemons
    ./programming-languages
    ./programs
    ./scripts
    ./services
    ./shells
    ./terminals
    ./text-editors
    ./wms
    ./desktop-environments
    ./vcs
    ./packages.nix
    ./kde-plasma
    ./nixvim.nix
    ./git.nix
    # ./mercurial.nix
    ./xdg
    ./email.nix
    ./calendar.nix
    ./spotify.nix
    ./environment-variables.nix
    ./fonts.nix
    ./pgp.nix
  ];

  home.enableDebugInfo = false;

  # TODO: set up `localsend` service to start in background
  # TODO: add home-manager support to nixd
  # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
  manual = {
    # Disable installation of various manual formats to save space
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  news.display = "notify";

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = null;
  };

  systemd.user.startServices = "sd-switch";

  # automatically set some environment variables that will ease usage of software installed with nix on non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc.)
  # targets.genericLinux.enable = false;

  programs.btop.enable = false;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.jq.enable = true;

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  services.network-manager-applet.enable = false;

  gtk.enable = true;

  gtk.theme = {
    # name = "adw-gtk3";
    name = "Adwaita";
    package = pkgs.adw-gtk3;
  };

  gtk.gtk2.extraConfig = ''gtk-application-prefer-dark-theme = 1'';

  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  qt.enable = true;
  # qt.style.name = "kvantum";
  # qt.platformTheme.name = "kvantum";
  # qt.style.catppuccin.enable = false;
  catppuccin.kvantum.enable = false;
  # qt.style.name = "breeze";
  # qt.platformTheme.name = "kde";

  qt = {
    style.package = [
      inputs.darkly.packages.${pkgs.system}.darkly-qt5
      inputs.darkly.packages.${pkgs.system}.darkly-qt6
    ];
    platformTheme.name = "qtct";
  };

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  # services.poweralertd.enable = osConfig.services.upower.enable;
  services.poweralertd.enable = true;

  programs.openscad.enable = true; # custom-modules/openscad.nix

  # custom-modules/gitu.nix
  programs.gitu = {
    enable = true;
    settings = {
      general.show_help.enabled = true;
    };
  };

  programs.nix-your-shell.enable = true;

  programs.kubecolor = {
    enable = false;
    enableAlias = true;
  };

  programs.cavalier = {
    enable = true;
  };
}
