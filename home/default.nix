{ pkgs, ... }:
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

    ./packages.nix
    ./kde-plasma.nix
    ./nixvim.nix
    ./packages.nix
    ./git.nix
    ./xdg.nix
    ./email.nix
    ./calendar.nix
    ./spotify.nix
    ./environment-variables.nix
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

  programs.btop.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.jq.enable = true;

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  services.network-manager-applet.enable = true;

  gtk.enable = true;
  gtk.theme = {
    name = "adw-gtk3";
    package = pkgs.adw-gtk3;
  };

  qt.enable = true;
  # qt.style.name = "kvantum";
  # qt.platformTheme.name = "kvantum";
  qt.style.catppuccin.enable = false;
  qt.style.name = "breeze";
  qt.platformTheme.name = "kde";
}
