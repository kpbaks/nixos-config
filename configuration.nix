{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./networking.nix
    ./zsa.nix
    ./wacom-intuos.nix
    ./power-management.nix
    ./steam.nix
    ./wireguard.nix
    # ./hdmi-cec.nix
    # ./tuxedo-laptop-second-nvme-drive.nix
  ];

  nix.settings.use-xdg-base-directories = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    # "auto-allocate-uids"
    # "ca-derivations"
    # "cgroups"
    # "no-url-literals"
    # "parse-toml-timestamps"
    # "repl-flake"
  ];
  # TODO: remove keys and caches here as they are specified in `./flake.nix`
  nix.settings.builders-use-substitutes = true;
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    # "https://cosmic.cachix.org/"
  ];
  nix.settings.extra-substituters = [
    # "https://anyrun.cachix.org"
    "https://yazi.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  ];
  nix.settings.extra-trusted-public-keys = [
    # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
  ];
  nix.settings.trusted-substituters = [ "https://cache.nixos.org" ];

  nix.settings.trusted-users = [
    # "root"
    username
  ];

  nix.settings.warn-dirty = false;

  nix.checkConfig = true;
  nix.checkAllErrors = true;

  # TODO: can this be made dependent on the running machine e.g. NumCPU / 2
  nix.settings.cores = 10; # number of cores per build, think `make -j N`
  nix.settings.max-jobs = 6; # number of builds that can be ran in parallel
  nix.settings.auto-optimise-store = true; # automatically detects files in the store that have identical contents, and replaces them with hard links to a single copy
  # nix.settings.access-tokens = [ "github.com=" ];

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "22:30" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Allow unfree packages e.g. closed-source nvidia drivers
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = false;

  # Needed by `nixd` lsp
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d --keep 10";
    flake = "/etc/nixos";
  };

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
  systemd.tmpfiles.rules = [ "L /lib - - - - /run/current/system/lib" ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.timeout = 10; # seconds (default is 5)
  # boot.loader.timeout = null; # wait indefinitely for user to select
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = false;
  boot.loader.systemd-boot.configurationLimit = 10; # Make it harder to fill up /boot partition
  boot.loader.systemd-boot.consoleMode = "max";

  # TODO: try out using `grub` instead of `systemd-boot`
  # https://discourse.nixos.org/t/change-bootloader-from-systemd-to-grub/5977
  # boot.loader.grub = {
  #   enable = true;
  #   useOSProber = false;
  #   device = "/dev/sda";
  #   efiSupport = true;
  # };

  boot.enableContainers = true;
  boot.supportedFilesystems = {
    ntfs = true; # Be able to mount USB drives with NTFS fs
    # btrfs = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_13;
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.plymouth =
    let
      # theme = "rings";
      theme = "glitch";
    in
    {
      enable = false;
      inherit theme;
      # TODO: make jetbrains mono available instead
      # font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      # theme = "rings";
      # TODO: checkout
      # https://github.com/helsinki-systems/plymouth-theme-nixos-bgrt
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ theme ];
          # nixosBranding = true;
          # nixosVersion = config.system.nixosRelease;
        })
      ];
    };

  # https://www.kernel.org/doc/html/latest/core-api/printk-basics.html
  boot.consoleLogLevel = 5;
  # boot.initrd.verbose = false;
  boot.kernelParams = [
    "tuxedo_keyboard.mode=0"
    "tuxedo_keyboard.brightness=255"
    # "quiet"
    "splash"
    "boot.shell_on_fail"
    "rd.systemd.show_status=true"
    "rd.udev.log_level=3"
    "udev.log_priority=3"

    "audit=off" # disable noisy audit and audit log
    # "mitigations=off" # might be a security issue, but slight performance gain :D
    "nowatchdog"
  ];

  # Hide the OS choice for bootloaders.
  # It's still possible to open the bootloader list by pressing any key
  # It will just not appear on screen unless a key is pressed
  # boot.loader.timeout = 0;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libGL
    libappindicator-gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    pango
    pipewire
    stdenv.cc.cc
    vulkan-loader
    # libegl
    # xorg.libX11
    # xorg.libXScrnSaver
    # xorg.libXcomposite
    # xorg.libXcursor
    # xorg.libXdamage
    # xorg.libXext
    # xorg.libXfixes
    # xorg.libXi
    # xorg.libXrandr
    # xorg.libXrender
    # xorg.libXtst
    # xorg.libxcb
    # xorg.libxkbfile
    # xorg.libxshmfence
    zlib
  ];
  # programs.direnv.enable = true;

  # TODO: why enabled?
  hardware.i2c.enable = true;

  hardware.tuxedo-drivers.enable = true;
  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  # https://lavafroth.is-a.dev/post/android-phone-for-webcam-nixos/
  boot.extraModulePackages = with pkgs; [ linuxPackages_latest.v4l2loopback ];
  # Opening libva device from DRM device /dev/dri/renderD128
  # [h264_vaapi @ 0x563ed816dd00] No usable encoding profile found.
  # failed to open encoder in low_power mode (Function not implemented), trying non low_power mode. if you have an intel iGPU, set enable_guc=2 in the i915 module to use the fixed function encoder. pass --low-power=off to suppress this warning
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Webcam"
    options i915 enable_guc=2
  '';

  # FIXME: 'evdi' not found
  boot.kernelModules = [
    # TODO: create a hardware. module for this and upstream
    "hid-playstation" # needed for bluetooth connectivity to playstation 4 and 5 dualshock controllers, ref: https://www.phoronix.com/news/Sony-DualShock4-PlayStation-Drv
    "evdi"
    "kvm-intel" # support for hardware virtualisation with Intel CPUs
    # "kvm-amd"
    # "tuxedo_keyboard"
  ];
  # boot.kernelParams = [
  #   "tuxedo_keyboard.mode=0"
  #   "tuxedo_keyboard.brightness=255"
  #   # "tuxedo_keyboard.color_left=0xff0a0a"
  # ];

  programs.droidcam.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    settings = { };
    input = { };
    network = { };
  };

  # hardware.ubertooth.enable = config.hardware.bluetooth.enable;

  # Make it possible to run downloaded appimages
  # boot.binfmt.registrations.appimage = {
  #   wrapInterpreterInShell = false;
  #   interpreter = "${pkgs.appimage-run}/bin/appimage-run";
  #   recognitionType = "magic";
  #   offset = 0;
  #   mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
  #   magicOrExtension = ''\x7fELF....AI\x02'';
  # };

  programs.appimage.enable = false;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs =
      pkgs: with pkgs; [
        ffmpeg
        imagemagick
      ];
  };
  environment.variables = {
    # EDITOR = "hx";
    # EDITOR = pkgs.lib.getExe pkgs.helix;
    # NIXPKGS_ALLOW_UNFREE = "1";
    # LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
    # https://jqlang.github.io/jq/manual/#colors
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,l:localhost,internal.domain";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.i18n.defaultLocale;
    LC_IDENTIFICATION = config.i18n.defaultLocale;
    LC_MEASUREMENT = config.i18n.defaultLocale;
    LC_MONETARY = config.i18n.defaultLocale;
    LC_NAME = config.i18n.defaultLocale;
    LC_NUMERIC = config.i18n.defaultLocale;
    LC_PAPER = config.i18n.defaultLocale;
    LC_TELEPHONE = config.i18n.defaultLocale;
    LC_TIME = config.i18n.defaultLocale;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.displayManager.defaultSession = "niri";

  # Enable the KDE Plasma Desktop Environment.
  # TODO: try out https://github.com/khaneliman/catppuccin-sddm-corners
  services.displayManager.sddm = {
    enable = true;
    # catppuccin.enable = true;
    wayland.enable = true;
    # autoNumlock = true;
    # https://man.archlinux.org/man/sddm.conf.5
    settings = {
      Users = {
        RememberLastUser = true;
        RememberLastSession = true;
      };
      # Autologin = {
      # Session = "niri";
      # User = username;
      # };
    };
  };

  services.desktopManager.gnome.enable = false;
  # Exclude applications installed with Gnome
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany
    geary
    evince
  ];

  services.desktopManager.plasma6.enable = true;

  # TODO: change to en_US
  # Configure keymap in X11
  services.xserver.xkb.layout = "us,dk";
  services.xserver.xkb.variant = "";

  # services.xserver.videoDrivers = ["displaylink" "modesetting" "nvidia"];
  # services.xserver.videoDrivers = ["displaylink" "modesetting"];
  services.xserver.videoDrivers = [ "modesetting" ];
  # services.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  # '';

  # nixpkgs.config.packageOverrides = pkgs: {
  #   # Needed for `wl-screenrec`
  #   # https://github.com/intel/intel-hybrid-driver
  #   # `intel-hybrid-driver` is deprecated
  #   # intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  # };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Needed for `wl-screenrec`
      # intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
      vpl-gpu-rt
      # intel-vaapi-driver # For older processors. LIBVA_DRIVER_NAME=i965
    ];
  };

  # Configure console keymap
  # console.keyMap = "dk-latin1";
  console.keyMap = "us";
  # console.font = "JetBrainsMono Nerd Font Mono"; # FIXME: not found

  # Enable CUPS to print documents.
  services.printing.enable = false;
  # services.blueman.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  # nixpkgs.config.pulseaudio = true;
  services.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
  services.pulseaudio.package = pkgs.puleaudioFull;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    package = pkgs.pipewire.override { x11Support = false; };
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  # users.defaultUserShell = pkgs.nushell;
  # users.defaultUserShell = pkgs.bash;
  users.users.${username} = {
    isNormalUser = true;
    description = "Kristoffer Sørensen";
    # TODO: document why it is necessary to be part of each group
    # TODO: use lib.optional to simplify
    extraGroups = pkgs.lib.lists.unique (
      [
        "networkmanager"
        "wheel"
        "docker"
        "storage"
        "i2c-dev"
      ]
      ++ (lib.optional config.virtualisation.podman.enable "podman")
      ++ (
        # https://nixos.wiki/wiki/Android
        lib.optionals config.programs.adb.enable [
          "adbusers"
          "kvm"
        ]
      )
    );
    packages = [ ]; # managed by home-manager, see ./home.nix
  };
  # TODO: document
  users.groups.input.members = [ username ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    nerd-fonts.victor-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.commit-mono
    nerd-fonts.iosevka
    nerd-fonts.fantasque-sans-mono
    cantarell-fonts
    font-awesome
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    rio
    cyme # a fancier `lsusb`
    psmisc
    busybox
    gnumake
    # mullvad-closest
    # rainfrog
    wayland-utils
    alsa-utils # `alsamixer`
    # fh # flakehub cli
    # adbfs-rootless # TODO: only if adb is enabled

    # TODO: checkout and experiment with (tir 10 sep 21:58:53 CEST 2024)
    # TODO: a laptop does not have numa
    # numactl
    # numad
    # numatop
    inetutils
    # inputs.nixos-cli.packages.${system}.default
    # scrcpy # TODO: only if adb is enabled

    # distrobox
    libinput
    # qemu
    # quickemu
    v4l-utils
    edid-decode
    keyd
    libva-utils # `vainfo`
    mozwire
    # Gaming
    kitty
    # mangohud
    # protonup
    # protonup-qt
    # lutris
    # heroic
    # bottles
    wget
    atool # {,de}compress various compression formats
    # helix # text editor
    git
    gh
    # Linux
    # btrfs-progs # Tools to interact with btrfs file system partitions
    udev
    systemctl-tui
    # systeroid # A more powerful alternative to sysctl(8) with a terminal user interface 🐧
    kmon # tui to view state of loaded kernel modules
    lshw # list hardware
    pciutils # `lscpi`
    lsof # "List open file descriptors"
    # nvtopPackages.full
    ddcutil # control external displays, such as changing their brightness
    findutils # find, locate
    moreutils # `sponge` etc.

    # Nix(os) tools
    hydra-check
    nix-prefetch-scripts
    nixfmt-rfc-style
    nix-output-monitor # `nom`
    nvd # nix version diff
    cachix
    nix-du
    nix-btm
    nix-derivation
    nix-doc
    nix-health
    nix-inspect
    nix-janitor
    statix # nix linter
    deadnix # detect unused nix code
    nixd # nix lsp
    manix # TODO: what does it do?
    comma
    nurl

    # Networking inspection tools
    ipinfo
    dig # lookup dns name resolving
    dogdns # lookup dns name resolving, but in rust!
    nmap
    # sniffnet

    (pkgs.writers.writeFishBin "logout" { }
      # fish
      ''
        set -l session_ids (${pkgs.systemd}/bin/loginctl list-sessions \
        | ${pkgs.coreutils}/bin/tail +2 \
        | ${pkgs.coreutils}/bin/head -1 \
        | string match --regex '\d')

        if test (count $session_ids) -gt 1
        # TODO: check if in a tty, or send a notify-send
          printf '%serror%s: more than one login session active. Not sure what to do, sorry.\n' (set_color red) (set_color normal) >&2
          return 1
        end

        # TODO: change colors to be more legible
        ${pkgs.gum}/bin/gum confirm "Logout?" --default=true --affirmative "Yes" --negative "No"
        and ${pkgs.systemd}/bin/loginctl kill-session $session_ids[1]

      ''
    )
    (pkgs.writers.writeFishBin "nixos-diff" { }
      # fish
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
      ''
    )
  ];

  programs.niri.enable = true;
  # programs.niri.package = pkgs.niri;
  programs.niri.package = pkgs.niri-unstable;

  # hardware.system76.power-daemon.enable = true;
  services.system76-scheduler.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # services.netbird.enable = true;

  services.flatpak.enable = true;
  systemd.services.add-flathub-remote = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
  };

  # security.pam.services.gdm.enableGnomeKeyring = false;
  security.pam.services.gdm.enableGnomeKeyring = false;
  programs.seahorse.enable = false;
  # services.gnome.gnome-keyring.enable = false;
  # programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

  programs.ssh = {
    askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
    startAgent = true;
  };
  services.gnome.gcr-ssh-agent.enable = !config.programs.ssh.startAgent;
  programs.git.lfs.enablePureSSHTransfer = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # It is annoying to sometimes reboot/shutdown and having to wait 2 ENTIRE minutes, which is the default,
  # for Systemd to wait patiently for a program to terminate.
  # FIXME: this is not always respected it seems. Figure out why, and how to fix it
  # systemd.extraConfig = ''
  #   DefaultTimeoutStopSec=15s
  # '';
  # https://www.freedesktop.org/software/systemd/man/latest/systemd-system.conf.html
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "15s";
  };

  # Prevent OOM when building with nix e.g. `nixos-rebuild switch`
  # By setting the maximum allowed usage of memory at the same time to be lower than the installed
  # currently: laptop with 16 GiB
  # TODO: can this be made dependent on the host builder e.g. 80% of total mem
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

  virtualisation.containers.enable = true;
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;

  # /etc/containers/containers.conf
  # virtualisation.containers.containersConf.settings = {
  #   # Disable warning log when using podman-compose wrapper
  #   compose_warning_logs = false;
  # };

  virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = false;
    extraPackages = [
      pkgs.gvisor
    ];
    # Users must be in the podman group in order to connect. As with Docker, members of this group can gain root access.
    dockerSocket.enable = builtins.elem "podman" config.users.users.${username}.extraGroups;
    autoPrune.enable = false;
    autoPrune.dates = "monthly";
    defaultNetwork.settings.dns_enabled = true;
    dockerCompat = !config.virtualisation.docker.enable;
  };

  # needed for `darkman`
  # services.geoclue2.enable = false;
  # NOTE: temporary fix reported by: https://github.com/NixOS/nixpkgs/issues/327464
  environment.etc."geoclue/conf.d/.valid".text = ''created the directory.'';
  location.provider = "geoclue2";

  # show dots when typing password for sudo
  # TODO: create or find tree-sitter grammar for this syntax and integrate into helix
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

  # FIXME: make work
  services.blocky = {
    enable = false;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
      #Enable Blocking of certain domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
          #Another filter for blocking adult sites
          adult = [ "https://blocklistproject.github.io/Lists/porn.txt" ];
          #You can add additional categories
          # social-media = [""];
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = [
            "ads"
            "adult"
          ];
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

  # programs.regreet.enable = config.services.greetd.enable;
  programs.regreet.enable = false;
  # https://github.com/rharish101/ReGreet

  # services.greetd = {
  #   enable = !config.services.displayManager.sddm.enable;
  #   settings = {
  #     # default_session.command = ''${pkgs.greetd.regreet}/bin/regreet'';
  #     # default_session.command = ''
  #     #   ${pkgs.greetd.tuigreet}/bin/tuigreet \
  #     #     --time \
  #     #     --remember \
  #     #     --asterisks \
  #     #     --user-menu \
  #     #     --cmd niri-session
  #     # '';
  #   };
  # };

  # niri-session
  environment.etc."greetd/environments".text = '''';

  services.fwupd.enable = true;

  # https://github.com/Shinyzenith/nix-dotfiles/blob/master/host/default.nix
  #   system = {
  #   stateVersion = "23.05";
  #   activationScripts.diff = {
  #     supportsDryActivation = true;
  #     text = ''
  #       ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
  #     '';
  #   };
  # };

  programs.kdeconnect.enable = true;
  programs.localsend.enable = false;
  programs.nm-applet.enable = false;
  programs.usbtop.enable = false;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
        };
      };
    };
  };

  # To theme GTK applications and Gnome
  programs.dconf.enable = true;

  # TODO: checkout this
  # https://github.com/Mic92/dotfiles/blob/main/nixos/modules/suspend-on-low-power.nix

  # *** Android ***
  # sudo waydroid upgrade
  # TODO: get this working
  # virtualisation.waydroid.enable = false;
  # programs.adb.enable = true;

  # TODO: `systemctl status avahi-daemon.service` prints this, fix it (tir 10 sep 17:35:56 CEST 2024)
  # WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
  # *** WARNING: Detected another IPv4 mDNS stack running on this host. This makes mDNS unreliable and is thus not recommended. ***
  services.avahi.enable = true;

  # TODO: enable if you ever get a device that has this sensor
  # hardware.sensor.iio.enable = false;

  # services.vnstat.enable = false;

  # TODO: try this service
  # services.netdata.enable = true;

  systemd.oomd.enable = true;
  systemd.oomd.enableUserSlices = true;
  # systemd.oomd.extraConfig = { };
  # services.earlyoom.enable = true;

  # TODO(ons 18 sep 10:53:21 CEST 2024): figure out how to configure `niri` and logind
  # to power off the laptop monitor, when the lid is closed and it is
  # connected to an external display.
  # When the lid is then transitioning from "closed" -> "open" it should
  # reconnect the monitor/output
  # (closed, disconnect-external) => suspend|hibernate

  # The lid state of a laptop monitor can be read from the file /proc/acpi/button/lid/*/state
  # services.logind = rec {
  #   killUserProcesses = true;
  #   powerKey = "hybrid-sleep";
  #   powerKeyLongPress = "poweroff";
  #   lidSwitchDocked = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchExternalPower = lidSwitch;

  #   extraConfig = "";
  # };

  # services.acpid = {
  #   enable = true;
  #   logEvents = false;
  #   lidEventCommands = '''';
  #   # powerEventCommands = ;
  # };

  # services.upower = {
  #   enable = true;
  #   percentageLow = 10;
  #   percentageCritical = 5;
  #   criticalPowerAction = "HybridSleep";
  #   # ignoreLid = false;
  # };

  programs.bandwhich.enable = true;

  # TODO: check if works in wsl?
  services.envfs.enable = false; # use fusefs to resolve shebangs like #!/bin/bash that does not work on NixOS because of not being compliant with FHS standard

  # https://www.postgresql.org/docs/18/color.html
  # environment.variables = {
  #   PG_COLOR = "auto";
  #   PG_COLORS = "";
  # };

  # services.cpupower-gui.enable = true;
  # programs.coolercontrol.enable = true;

  # echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'
  # echo 'enabled' > '/sys/class/net/wlan0/device/power/wakeup'
  # echo 'enabled' > '/sys/bus/usb/devices/4-4.1/power/wakeup'
  #

  programs.obs-studio = {
    enable = false;
    enableVirtualCamera = true;
  };

  zramSwap = {
    enable = true;
  };
  environment.enableAllTerminfo = true;

  # TODO: wrap .desktop file Exec entry in a call to run0 or kdialog with sudo to run as root
  programs.sniffnet.enable = false;

  # networking.hosts = {
  #   "127.0.0.1" = [
  #     "reddit.com"
  #     "instagram.com"
  #   ];
  # };

  services.desktopManager.cosmic.enable = false;
  services.displayManager.cosmic-greeter.enable = false;

  # programs.command-not-found.dbPath
  programs.command-not-found.enable = true;

  systemd.enableStrictShellChecks = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  # TODO: figure out a way to integrate with zellij for true session
  # resurrection
  programs.criu.enable = true;
  programs.systemtap.enable = false;

  # Nicing the nix daemon is a great way to let it automatically get pushed to the back of the line when you're using the machine while still being able to utilize all of it for builds that are holding up your launch.
  # ref: https://positron.solutions/articles/building-nicely-with-rust-and-nix
  systemd.services.nix-daemon.serviceConfig = {
    Nice = lib.mkForce 15;
    IOSchedulingClass = lib.mkForce "idle";
    IOSchedulingPriority = lib.mkForce 7;
  };

  # Needed for noctalia shell (https://docs.noctalia.dev/getting-started/nixos/#installation)
  services.upower.enable = true;
}
