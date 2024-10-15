{
  # config,
  # osConfig,
  pkgs,
  inputs,
  # system,
  # username,
  ...
}:
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./kate.nix
    ./konsole.nix
    ./okular.nix
    ./kdeconnect.nix

  ];

  programs.plasma.enable = true;

  # programs.plasma.kwin.enable = true;
  # programs.plasma.scripts.polonium.enable = true;

  programs.plasma.spectacle.shortcuts = {
    # launch = null;
    # enable = true;
  };

  programs.plasma.workspace.cursor = {
    size = 24;
    theme = "Breeze_Snow";
    # theme = "Bibata-Modern-Ice";
  };

  programs.plasma.workspace.iconTheme = "Papirus";
  programs.plasma.workspace.lookAndFeel = "org.kde.breeze.desktop";

  #
  # Some high-level settings:
  #
  programs.plasma.workspace = {
    clickItemTo = "select";
    wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
  };

  programs.plasma.panels = [
    # Windows-like panel at the bottom
    {
      location = "bottom";
      widgets = [
        "org.kde.plasma.kickoff"
        "org.kde.plasma.icontasks"
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.systemtray"
        "org.kde.plasma.digitalclock"
      ];
    }
    # Global menu at the top
    {
      location = "top";
      height = 26;
      widgets = [ "org.kde.plasma.appmenu" ];
    }
  ];

  #
  # Some low-level settings:
  #
  programs.plasma.configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;

  programs.plasma.configFile.kwinrc = {
    "org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
    Desktops.Number = {
      value = 3;
      # Forces kde to not change this value (even through the settings app).
      immutable = true;
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  home.packages = with pkgs.kdePackages; [
    neochat
    klevernotes
  ];
}
