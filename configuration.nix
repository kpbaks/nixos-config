# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  username,
  ...
}
: rec {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./tuxedo-laptop-second-nvme-drive.nix
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    builders-use-substitutes = true;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-substituters = [
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
    trusted-substituters = ["https://cache.nixos.org"];
  };

  nix.settings.trusted-users = [
    "root"
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

  # fileSystems."/mnt/ssd1" = {
  #   # fsType = "btrfs";
  #   fsType = "ext4";
  #   # device = "/dev/nvme0n1p1";
  #   device = "/dev/disk/by-uuid/52D0-5E93";
  #   # https://manpages.ubuntu.com/manpages/noble/en/man8/mount.8.html#filesystem-independent%20mount%20options
  #   # options = [
  #   #   "users" # Allows any user to mount and unmount
  #   #   "nofail" # Prevent system from failing if this drive doesn't mount
  #   #   "exec" # Permit execution of binaries and other executable files.
  #   #   "rw" # Mount the filesystem read-write.
  #   # ];
  # };

  # allow `perf` as user
  boot.kernel.sysctl."kernel.perf_event_paranoid" = -1;
  boot.kernel.sysctl."kernel.kptr_restrict" = pkgs.lib.mkForce 0;

  # so `perf` can find kernel modules
  systemd.tmpfiles.rules = [
    "L /lib - - - - /run/current/system/lib"
  ];

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
  # FIXME: 'evdi' not found
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

  # Make it possible to run downloaded appimages
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # TODO: get steam to work
  specialisation.gaming.configuration = {
    system.nixos.tags = ["gaming"];
    # Nvidia Configuration
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.prime = let
      inherit (pkgs.lib) mkForce;
    in {
      sync.enable = mkForce false;
      offload = rec {
        enable = mkForce true;
        enableOffloadCmd = enable;
      };

      # NOTE: ids found with `lspci | grep VGA`
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:01:00:0";
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:00:02:0";
    };

    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "555.52.04";
    #   sha256_64bit = "sha256-nVOubb7zKulXhux9AruUTVBQwccFFuYGWrU1ZiakRAI=";
    #   sha256_aarch64 = pkgs.lib.fakeSha256;
    #   openSha256 = pkgs.lib.fakeSha256;
    #   settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
    #   persistencedSha256 = pkgs.lib.fakeSha256;
    # };
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
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
  services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "dk";
  services.xserver.xkb.variant = "";

  # services.xserver.videoDrivers = ["displaylink" "modesetting" "nvidia"];
  # services.xserver.videoDrivers = ["displaylink" "modesetting"];
  services.xserver.videoDrivers = ["modesetting"];
  # services.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  # '';

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure console keymap
  # TODO: change to en-us
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = false;
  # services.blueman.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;

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
    extraGroups = ["networkmanager" "wheel" "docker" "podman" "storage"];
    packages = []; # managed by home-manager, see ./home.nix
  };
  users.groups.input.members = [username];

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "Iosevka" "VictorMono" "NotoSans"];})
    cantarell-fonts
    # line-awesome
    font-awesome
    # font-awesome_5
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    mangohud
    protonup
    protonup-qt
    btrfs-progs
    lutris
    heroic
    bottles

    chase
    nh # nix helper
    nix-output-monitor # `nom`
    nvd # nix version diff
    systemctl-tui
    wget
    atool # {,de}compress various compression formats
    helix # text editor
    alejandra # nix formatter
    nixpkgs-fmt
    doas # sudo alternative
    cachix
    udev
    dig # lookup dns name resolving
    dogdns # loopup dns name resolving, but in rust!
    nmap
    # tmux
    wl-clipboard
    sniffnet
    git
    gh
    lshw # list hardware
    pciutils # `lscpi`
    # nvtopPackages.full
    ddcutil # control external displays, such as chaning their brightness
    (pkgs.writers.writeFishBin "logout" {}
      /*
      fish
      */
      ''
        set -l session_ids (${pkgs.systemd}/bin/loginctl list-sessions \
        | ${pkgs.coreutils}/bin/tail +2 \
        | ${pkgs.coreutils}/bin/head -1 \
        | string match --regex '\d')

        if test (count $session_ids) -gt 1
          printf '%serror%s: more than one login session active. Not sure what to do, sorry.\n' (set_color red) (set_color normal) >&2
          return 1
        end

        ${pkgs.gum}/bin/gum confirm "Logout?" --default=true --affirmative "Yes" --negative "No"
        and ${pkgs.systemd}/bin/loginctl kill-session $session_ids[1]

      '')
    (pkgs.writers.writeFishBin
      "nixos-diff"
      {}
      /*
      fish
      */
      ''
        set -l reset (set_color normal)
        set -l red (set_color red)
        set -l options v/verbose h/help
        argparse $options -- $argv; or return 2

        set -l generations (string match --regex --groups-only '(\d+)' /nix/var/nix/profiles/system-*-link | ${pkgs.coreutils}/bin/sort --numeric-sort)
        if test 1 -eq (count $generations)
          # Nothing to compare with only 1 generation
          printf '%serror%s: only one profile exists, nothing to compare!\n' $red $reset >&2
          return 1
        end

        set -l a
        set -l b 0

        set -l argc (count $argv)
        switch $argc
          case 0
            # Diff latest profile with the second latest (or the largest one < latest, if that can even happen ...)
            # NOTE: use `readlink` instead of `path resolve` as we only want to resolve the symlink once, and not recursively.
            set -l active (${pkgs.coreutils}/bin/readlink /nix/var/nix/profiles/system)
            set b (string match --regex --groups-only '(\d+)' -- $active)
          case 1
            # Diff `$argv[1]` with `$argv[1] - 1`
            # Error if `$argv[1] == 1`
            set b $argv[1]
          case 2
            # Diff `$argv[1]` with `$argv[2]`
            # invariant: `$argv[1] < $argv[2]`
            set a $argv[1]
            set b $argv[2]
          case '*'
            # Error
        end

        if not contains -- $b $generations
          printf '%serror%s: "%s" does not match any existing generation ids: [ %s ]\n' $red $reset $b (string join ' ' $generations) >&2
          return 2
        end

        if test -z $a
          set -l b_idx (contains --index -- $b $generations)
          if test $b_idx -eq 1
          printf '%serror%s: when only a single argument is given the upper "%s" cannot be the oldest generation id, pick any of: [ %s ]\n' $red $reset $b (string join ' ' $generations[2..]) >&2
            return 2
          end
          set -l a_idx (math "$b_idx - 1")
          set a $generations[$a_idx]
        end

        if not contains -- $a $generations
          printf '%serror%s: "%s" does not match any existing generation ids: [ %s ]\n' $red $reset $a (string join ' ' $generations) >&2
          return 2
        end

        set -l expr ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/system-{$a,$b}-link

        echo "evaluating expression:"
        echo $expr | ${pkgs.fish}/bin/fish_indent --ansi
        echo

        eval $expr
      '')
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  # programs.river.enable = true;

  # qt.enable = true;
  # qt.style = "breeze";
  # qt.platformTheme = "kde";

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
  # FIXME: get to work
  #   services.espanso.enable = false;
  services.mullvad-vpn.enable = true;

  # security.pam.services.gdm.enableGnomeKeyring = false;
  security.pam.services.gdm.enableGnomeKeyring = false;
  programs.seahorse.enable = false;
  # services.gnome.gnome-keyring.enable = false;
  programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      librewolf = {
        executable = "${pkgs.librewolf}/bin/librewolf";
        profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
        extraArgs = [
          # Required for U2F USB stick
          "--ignore=private-dev"
          # Enforce dark mode
          "--env=GTK_THEME=Adwaita:dark"
          # Enable system notifications
          "--dbus-user.talk=org.freedesktop.Notifications"
        ];
      };
    };
  };

  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  # programs.steam = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     gamescope
  #   ];
  #   # remotePlay.openFirewall = false;
  # };

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

  # It is annoying to sometimes reboot/shutdown and having to wait 2 ENTIRE minutes, which is the default,
  # for Systemd to wait patiently for a program to terminate.
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  # Prevent OOM when building with nix e.g. `nixos-rebuild switch`
  # By setting the maximum allowed usage of memory at the same time to be lower than the installed
  # currently: laptop with 16 GiB
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

  # virtualisation.containers.enable = true;
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = true;
  #   extraPackages = with pkgs; [criu];
  # };

  # virtualisation.podman = {
  #   enable = false;
  # };

  # services.mosquitto = {
  #   enable = true;
  #   listeners = [
  #     {
  #       acl = ["pattern readwrite #"];
  #       omitPasswordAuth = true;
  #       settings.allow_anonymous = true;
  #     }
  #   ];
  # };

  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [
  #     # (
  #     #   if services.mosquitto.enable
  #     #   then 1883
  #     #   else null
  #     # )
  #     # (pkgs.mkIf services.mosquitto.enable 1883 [])
  #   ];
  #   # ++ (
  #   #   if services.mosquitto.enable
  #   #   then [1883]
  #   #   else []
  #   # );
  # };

  # needed for `darkman`
  services.geoclue2.enable = true;
  # NOTE: temporary fix reported by: https://github.com/NixOS/nixpkgs/issues/327464
  environment.etc."geoclue/conf.d/.valid".text = ''created the directory.'';

  # show dots when typing password for sudo
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
  '';

  # TODO: create systemd timer for `nix run 'nixpkgs#nix-index'`

  # stylix = {
  #   enable = true;
  #   fonts = {
  #     # monospace = {
  #     #   # package = pkgs.nerdfotns

  #     # };
  #     serif = {
  #       package = pkgs.dejavu_fonts;
  #       name = "DejaVu Serif";
  #     };

  #     sansSerif = {
  #       package = pkgs.dejavu_fonts;
  #       name = "DejaVu Sans";
  #     };

  #     # TODO: jetbrains mono
  #     monospace = {
  #       package = pkgs.dejavu_fonts;
  #       name = "DejaVu Sans Mono";
  #     };

  #     emoji = {
  #       package = pkgs.noto-fonts-emoji;
  #       name = "Noto Color Emoji";
  #     };
  #   };
  #   # image = ./assets/imgs/macos-sequoia-dark.png;
  #   # image = ./macos-sequoia-light.png;
  #   opacity = {
  #     applications = 1.0;
  #     desktop = 1.0;
  #     terminal = 0.9;
  #   };
  #   polarity = "dark"; # or "light"
  #   targets.fish.enable = false;
  # };
  # stylix.targets.niri.enable = true;

  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = ["1.1.1.1" "1.0.0.1"];
      };
      #Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          #Another filter for blocking adult sites
          adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
          #You can add additional categories
          # social-media = [""];
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = ["ads" "adult"];
          # kids-ipad = ["ads" "adult"];
        };
      };
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };

  # KDE partition manager
  programs.partition-manager.enable = true;
}
