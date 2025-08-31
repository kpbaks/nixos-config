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
    inputs.plasma-manager.homeModules.plasma-manager
    ./kate.nix
    ./konsole.nix
    ./okular.nix
    ./kdeconnect.nix
    ./kcm.nix
    # ./klipper.nix

  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;
    immutableByDefault = true;
    windows.allowWindowsToRememberPositions = true;
  };

  programs.plasma.powerdevil = {
    general.pausePlayersOnSuspend = true;
    battery.powerProfile = "powerSaving";
    batteryLevels = {
      lowLevel = 20;
      criticalLevel = 5;
    };
  };

  programs.plasma.kscreenlocker = {
    timeout = 10; # min
  };

  programs.plasma.desktop = {
    icons = {
      lockInPlace = true;
      size = 4;
      sorting.foldersFirst = true;
      folderPreviewPopups = true;
      alignment = "left";
      arrangement = "topToBottom";
    };

    mouseActions = {
      verticalScroll = "switchVirtualDesktop";
    };
    widgets = [ ];
  };

  programs.plasma.krunner = {
    position = "center";
    activateWhenTypingOnDesktop = true;
    historyBehavior = "enableAutoComplete";
  };

  programs.plasma.fonts = {
    fixedWidth = {
      family = "JetBrains Mono";
      pointSize = 10;
    };
  };

  programs.plasma.input = {
    keyboard = {
      repeatRate = 50;
    };
    touchpads = [
      {
        # name, productId and vendorId found in /proc/bus/input/devices
        disableWhileTyping = true;
        enable = true;
        leftHanded = true;
        middleButtonEmulation = true;
        name = "UNIW0001:00 093A:0274 Touchpad";
        naturalScroll = false;
        pointerSpeed = 0;
        productId = "0274";
        tapToClick = true;
        vendorId = "093a";
      }
    ];

  };
  # programs.plasma.kwin.enable = true;
  # programs.plasma.scripts.polonium.enable = true;

  programs.plasma.spectacle.shortcuts = {
    # launch = null;
    # enable = true;
    # captureRectangularRegion = "Meta+Shift+S";
  };

  programs.plasma.workspace.cursor = {
    size = 32;
    theme = "Breeze_Snow";
    # theme = "Bibata-Modern-Ice";
  };

  # programs.plasma.workspace.iconTheme = "Papirus";
  # programs.plasma.workspace.lookAndFeel = "org.kde.breeze.desktop";

  #
  # Some high-level settings:
  #
  programs.plasma.workspace = {
    clickItemTo = "select";
    colorScheme = "Lightly"; # use `plasma-apply-colorscheme --list-schemes` for options
    # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
  };

  programs.plasma.panels = [
    # Windows-like panel at the bottom
    {
      location = "bottom";
      height = 52;
      floating = true;

      widgets = [
        "org.kde.plasma.kickoff"
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.icontasks"
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.systemtray"
        "org.kde.plasma.digitalclock"
      ];
    }
    # Global menu at the top
    # {
    #   location = "top";
    #   height = 26;
    #   widgets = [ "org.kde.plasma.appmenu" ];
    # }
  ];

  #
  # Some low-level settings:
  #
  programs.plasma.configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;

  programs.plasma.configFile.kwinrc = {
    "org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
    Desktops.Number = {
      value = 4;
      # Forces kde to not change this value (even through the settings app).
      immutable = true;
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  home.packages =
    with pkgs.kdePackages;
    [
      neochat
      # klevernotes
      akregator
      kasts
      merkuro
      itinerary
      kolourpaint
      krohnkite
    ]
    ++ (with pkgs; [
      plasma-panel-colorizer
      # libsForQt5.plasma-bigscreen
    ]);

  # TODO: verify if this make the browser integration work with zen-browser
  # https://github.com/zen-browser/desktop/issues/349
  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    (pkgs.formats.json { }).generate "plasma_browser_integration_json"
      {
        allowed_extensions = [ "plasma-browser-integration@kde.org" ];
        description = "Native connector for KDE Plasma";
        name = "org.kde.plasma.browser_integration";
        path = "${pkgs.kdePackages.plasma-browser-integration}/bin/plasma-browser-integration-host";
        type = "stdio";
      };
}
