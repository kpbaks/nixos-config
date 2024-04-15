# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}
:
# let
#   tuxedo = import (builtins.fetchTarball "https://github.com/blitz/tuxedo-nixos/archive/master.tar.gz");
# in
let
  username = "kpbaks";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-substituters = ["https://cache.nixos.org"];
    };
  };

  nix.settings.trusted-users = [
    "root"
    # "kpbaks"
    username
  ];

  nix.checkConfig = true;
  nix.checkAllErrors = true;

  nix.settings.cores = 10; # number of cores per build, think `make -j N`
  nix.settings.max-jobs = 6; # number of builds that can be ran in parallel
  nix.settings.auto-optimise-store = true; # automatically detects files in the store that have identical contents, and replaces them with hard links to a single copy

  nix.optimise.automatic = true;
  nix.optimise.dates = ["22:30"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Allow unfree packages e.g. closed-source nvidia drivers
  nixpkgs.config.allowUnfree = true;

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.enableContainers = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"]; # Be able to mount USB drives with NTFS fs

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add shit here
  ];
  programs.direnv.enable = true;

  hardware.i2c.enable = true;

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };
  hardware.tuxedo-keyboard.enable = true;
  boot.kernelModules = ["evdi" "tuxedo_keyboard"];
  boot.kernelParams = [
    "tuxedo_keyboard.mode=0"
    "tuxedo_keyboard.brightness=255"
    # "tuxedo_keyboard.color_left=0xff0a0a"
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    settings = {};
  };

  # hardware.nvidia = {
  #   # Modesetting is required.
  #   modesetting.enable = true;

  #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #   powerManagement.enable = false;
  #   # Fine-grained power management. Turns off GPU when not in use.
  #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  #   powerManagement.finegrained = false;

  #   # Use the NVidia open source kernel module (not to be confused with the
  #   # independent third-party "nouveau" open source driver).
  #   # Support is limited to the Turing and later architectures. Full list of
  #   # supported GPUs is at:
  #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
  #   # Only available from driver 515.43.04+
  #   # Currently alpha-quality/buggy, so false is currently the recommended setting.
  #   open = false;

  #   # Enable the Nvidia settings menu,
  #   # accessible via `nvidia-settings`.
  #   nvidiaSettings = true;

  #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  specialisation = {
    # TODO: works but bevy breaks down when used as renderer
    nvidia.configuration = {
      system.nixos.tags = ["nvidia"];
      # Nvidia Configuration
      services.xserver.videoDrivers = ["nvidia"];
      hardware.opengl.enable = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
      # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      hardware.nvidia.modesetting.enable = true;

      hardware.nvidia.prime = {
        sync.enable = true;

        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:01:00:0";

        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:00:02:0";
      };
    };
    # nvidia-nouveau.configuration = {
    #   system.nixos.tags = ["nvidia-nouveau"];
    #   # Nvidia Configuration
    #   services.xserver.videoDrivers = ["nouveau"];
    #   hardware.opengl.enable = true;

    #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #   # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

    #   # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
    #   hardware.nvidia.modesetting.enable = true;

    #   hardware.nvidia.prime = {
    #     sync.enable = true;

    #     # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    #     nvidiaBusId = "PCI:01:00:0";

    #     # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    #     intelBusId = "PCI:00:02:0";
    #   };
    # };
  };

  environment.variables.EDITOR = "hx";
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,l:localhost,internal.domain";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "dk";
  services.xserver.xkb.variant = "";

  # services.xserver.videoDrivers = ["displaylink" "modesetting" "nvidia"];
  # services.xserver.videoDrivers = ["displaylink" "modesetting"];
  services.xserver.videoDrivers = ["modesetting"];
  # services.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  # '';

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = false;
  # services.blueman.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;

  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.extraModules = [pkgs.pulseaudio-modules-bt];
  hardware.pulseaudio.package = pkgs.puleaudioFull;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  # users.defaultUserShell = pkgs.bash;
  users.users.kpbaks = {
    isNormalUser = true;
    description = "Kristoffer Sørensen";
    extraGroups = ["networkmanager" "wheel" "docker" "podman"];
    packages = with pkgs; []; # managed by home-manager
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "Iosevka" "VictorMono"];})
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    atool
    helix
    alejandra
    doas
    cachix
    udev

    wl-clipboard
    sniffnet
    git
    lshw
    pciutils # lscpi
    nvtopPackages.full
    ddcutil
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.river.enable = true;

  qt.enable = true;
  qt.style = "breeze";
  qt.platformTheme = "kde";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  # services.netbird.enable = true;

  services.flatpak.enable = true;
  services.espanso.enable = true;
  services.mullvad-vpn.enable = true;
  # services.spotifyd.enable = true;
  # services.surrealdb.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # services.jitsi-meet = {
  #   enable = true;
  #   excalidraw.enable = true;
  # };

  # services.thermald.enable = true;
  # TODO: check out services.auto-cpufreq
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;

  #     # Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 20; # 20 and bellow it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #   };
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "8G";
    MemoryMax = "10G";
  };

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  #   wlr.enable = false;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-kde
  #   ];
  # };

  virtualisation.containers.enable = true;
  virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraPackages = with pkgs; [criu];
  };

  virtualisation.podman = {
    enable = false;
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = ["pattern readwrite #"];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [1883];
  };

  services.geoclue2.enable = true;
}
