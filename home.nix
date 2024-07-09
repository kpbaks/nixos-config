{
  config,
  # osConfig,
  pkgs,
  inputs,
  username,
  ...
} @ args: let
  name = "Kristoffer Sørensen";
  full-name = "Kristoffer Plagborg Bak Sørensen";
  # username = "kpbaks";
  gmail = "kristoffer.pbs@gmail.com";
  aumail = "201908140@post.au.dk";
  tutamail = "kristoffer.pbs@tuta.io";
  email = gmail;
  telephone-number = "21750049";
  # system = "x86_64-linux";
  config_dir = "/home/" + username + "/.config";
  cache_dir = "/home/" + username + "/.cache";
  data_dir = "/home/" + username + "/.local/share";
  city = "Aarhus";
  country = "Denmark";
  lib = pkgs.lib;
  join = lib.strings.concatStringsSep;
  mapjoin = lib.strings.concatMapStringsSep;
  range = from: to: builtins.genList (i: from + i) (to - from);
  merge = list: builtins.foldl' (acc: it: acc // it) {} list;
  font.monospace = "Iosevka Nerd Font Mono";
  monitors.laptop = "eDP-1";
  monitors.acer = "DP-5";
  terminal = pkgs.lib.getExe pkgs.kitty;
  # TODO: present more nicely maybe with the `tabulate` package
  scripts.PYTHONSTARTUP = pkgs.writers.writePython3Bin "pythonstartup.py" {flakeIgnore = ["E501"];} ''
    import pkgutil
    import sys
    from typing import Set


    def get_stdlib_modules() -> Set[str]:
        """Get a set of standard library module names."""
        stdlib_path = next(p for p in sys.path if 'site-packages' not in p and 'dist-packages' not in p)
        stdlib_modules = {name for _, name, _ in pkgutil.iter_modules([stdlib_path])}
        return stdlib_modules


    def get_installed_modules() -> Set[str]:
        """Get a set of installed module names."""
        installed_modules = {name for _, name, _ in pkgutil.iter_modules()}
        return installed_modules


    def get_external_modules() -> Set[str]:
        """Get a set of external (non-standard library) module names."""
        stdlib_modules = get_stdlib_modules()
        installed_modules = get_installed_modules()
        external_modules = installed_modules - stdlib_modules
        return external_modules


    external_modules = get_external_modules()
    print("External packages (not in stdlib):")
    for module in sorted(external_modules):
        print(module)
  '';
  scripts.wb-reload = pkgs.writers.writeBashBin "wb-reload" ''
    if ! ${pkgs.procps}/bin/pkill -USR2 waybar; then
      ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
    fi
  '';

  scripts.wb-toggle-visibility = pkgs.writers.writeBashBin "wb-toggle-visibility" ''
    if ! ${pkgs.procps}/bin/pkill -USR1 waybar; then
      # ${pkgs.libnotify}/bin/notify-send --transient --category= "waybar" "waybar is not running"
      ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
    fi
  '';

  scripts.wb-watch-config-and-reload = pkgs.writers.writeBashBin "wb-watch-config-and-reload" ''
    if ${pkgs.procps}/bin/pgrep waybar; then
      ${pkgs.watchexec}/bin/watchexec --watch /home/${username}/.config/waybar ${pkgs.lib.getExe scripts.wb-reload}
    else
      ${pkgs.libnotify}/bin/notify-send --transient "waybar" "waybar is not running"
    fi
  '';

  scripts.foobar = pkgs.writers.writeFish "foobar" ''echo foobar'';

  scripts.spotify-cover-art =
    pkgs.writers.writeFishBin "spotify-cover-art" {}
    /*
    fish
    */
    ''
      set -l cdn (${pkgs.playerctl}/bin/playerctl -p spotify metadata mpris:artUrl)
      if test -z $cdn
        # spotify not running
        exit
      end
      set -l cover /tmp/cover.jpeg
      ${pkgs.curl}/bin/curl --silent "$cdn" --output $cover
      echo $cover
      # if isatty stdout
      #   ${pkgs.timg}/bin/timg --center $cover
      # else
      #   echo $cover
      # end
    '';

  scripts.bluetoothctl-startup =
    pkgs.writers.writeFishBin "bluetoothctl-startup" {}
    /*
    fish
    */
    ''
      set -l reset (set_color normal)
      set -l red (set_color red)
      set -l blue (set_color blue)
      set -l green (set_color green)
      set -l yellow (set_color yellow)
      set -l cyan (set_color cyan)
      set -l magenta (set_color magenta)
      set -l bold (set_color --bold)

      ${pkgs.bluez}/bin/bluetoothctl help
      echo

      set -l devices (${pkgs.bluez}/bin/bluetoothctl devices)

      echo "devices: $(count $devices)"

      printf '%s\n' $devices | while read _device mac name
        echo $mac | read -d : a b c d e f
        printf '- %s%s%s:%s%s%s:%s%s%s:%s%s%s:%s%s%s:%s%s%s' $green $a $reset $yellow $b $reset $red $c $reset $blue $d $reset $cyan $e $reset $magenta $f $reset
        printf ' %s%s%s\n' $bold $name $reset
      end
      echo

      # start bluetoothctl repl
      ${pkgs.bluez}/bin/bluetoothctl
    '';
  scripts.show-session =
    pkgs.writers.writeFishBin "show-session" {}
    /*
    fish
    */
    ''

      set -l reset (set_color normal)
      set -l red (set_color red)
      set -l blue (set_color blue)
      set -l green (set_color green)
      set -l yellow (set_color yellow)
      set -l cyan (set_color cyan)
      set -l magenta (set_color magenta)
      set -l bold (set_color --bold)

      set -l properties
      set -l values
      ${pkgs.systemd}/bin/loginctl show-session | while read -d = property value
        set -a properties $property
        set -a values $value
      end

      set -l length_of_longest_property 0
      for p in $properties
        set length_of_longest_property (math "max $length_of_longest_property,$(string length $p)")
      end

      for i in (seq (count $properties))
        set -l p $properties[$i]
        set -l v $values[$i]
        set -l rpad (math "$length_of_longest_property - $(string length $p)")
        set rpad (string repeat --count $rpad ' ')

        set -l v_color $reset
        if test $v = yes
          set v_color $green
        else if test $v = no
          set v_color $red
        else if string match --regex --quiet '^\d+$' -- $v
          set v_color $magenta
        else if string match --regex --quiet '^\d+(s|min)$' -- $v
          set v_color $yellow
        end

        printf '%s%s%s%s = %s%s%s\n' $bold $p $reset $rpad $v_color $v $reset
      end
    '';
in rec {
  # TODO: consider using https://github.com/chessai/nix-std
  imports = [inputs.ags.homeManagerModules.default];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3" # needed for `logseq` 05-07-2024
  ];

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    configDir = null;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  # nix.settings = {
  #   # https://yazi-rs.github.io/docs/installation#cache
  #   extra-substituters = ["https://yazi.cachix.org"];
  #   extra-trusted-public-keys = ["yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="];
  # };

  accounts.calendar.basePath = home.homeDirectory + "/.calendars";
  accounts.calendar.accounts = {
    personal = {
      khal.enable = true;
      khal.color = "yellow";
      primary = true;
      remote = {
        type = "google_calendar";
        password = ["bw"];
      };
      vdirsyncer = {
        enable = true;
      };
    };
  };

  # catppuccin.flavour = "mocha";

  home.username = username;
  home.homeDirectory = "/home/" + username;

  # TODO: sync with `configuration.nix`
  home.stateVersion = "24.05";

  home.sessionVariables = {
    PAGER = "${pkgs.moar}/bin/moar";
    MOAR = "-statusbar=bold -no-linenumbers -quit-if-one-screen";
    # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
    PYTHONSTARTUP = pkgs.lib.getExe scripts.PYTHONSTARTUP;
  };

  # TODO: document all pkgs
  home.packages = with pkgs; [
    scripts.PYTHONSTARTUP
    scripts.bluetoothctl-startup
    scripts.spotify-cover-art
    scripts.show-session
    scripts.wb-reload
    scripts.wb-toggle-visibility
    scripts.wb-watch-config-and-reload
    helvum # GTK-based patchbay for pipewire
    watchexec
    # rerun # FIXME: does not compile
    logseq
    smassh # TUI based typing test application inspired by MonkeyType
    kondo #  cleans dependencies and build artifacts from your projects.
    # TODO: integrate with nvim
    statix # nix linter
    deadnix # detect unused nix code
    tickrs #  Realtime ticker data in your terminal 📈
    ticker #  Terminal stock ticker with live updates and position tracking
    mop #  Stock market tracker for hackers.
    newsflash # rss reader
    wl-color-picker
    # element
    element-desktop
    gping
    nixd
    kdePackages.plasma-workspace # for krunner
    fuzzel
    resvg
    miller
    csview
    # pympress
    mission-center
    mkchromecast
    samply
    sad
    sd
    # ungoogled-chromium
    vivaldi
    asciigraph
    imagemagick
    odin
    lychee
    tutanota-desktop
    localsend # open source alternative to Apple Airdrop
    inkscape
    gimp
    moar # a nice pager
    dogdns # rust alternative to dig
    zed-editor
    upx
    ripdrag # drag and drop files from the terminal
    caddy # Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS
    # charm-freeze
    pastel
    vivid
    wdisplays
    nwg-dock
    nwg-drawer
    nwg-displays
    daktilo # turn your keyboard into a typewriter!
    # lemmyknow # identify anything
    the-way # termial snippet-manager
    appflowy # open source alternative to notion
    macchina # neofetch like program
    neovim-remote # TODO: create `darkman` script to toggle light/dark mode with `set background=dark`
    lurk # like `strace` but with colors
    kdiff3
    meld
    spotify-player
    micro
    procs
    # jitsi
    # jitsi-meet
    nushell
    clipse # tui clipbard manager
    # gnomeExtensions.pano # fancy clipboard manager
    # starship # shell prompt generator
    # rerun
    devenv
    dragon
    ffmpeg
    ffmpegthumbnailer
    parallel
    libwebp # why do 'r/wallpaper' upload all its images in `webp`
    # tabnine
    # waybar
    # grit
    d2
    graphviz
    aria
    wofi
    # rofi-wayland
    pavucontrol # audio sink gui
    overskride # bluetooth gui
    wf-recorder # wayland screen recorder
    wl-screenrec # wayland screen recorder
    # ianny
    wluma
    wlsunset # set screen gamma (aka. night light) based on time of day
    poppler_utils # pdf utilities
    webcord # fork of discord, with newer electron version, to support screen sharing
    hyprshot # screenshot tool designed to integrate with hyprland
    grim # wayland screenshot tool
    slurp # wayland tool to make a screen selection
    udiskie # daemon used to automatically mount external drives like USBs
    # flameshot
    brightnessctl # control screen brightness
    thunderbird # email client
    # discord
    telegram-desktop # messaging client
    spotify # music player
    zotero # citation/bibliography manager
    copyq # clipboard manager
    libnotify # for `notify-send`
    swaylock
    hyprlock # wayland screen lock
    hypridle # hyprlands idle daemon
    hyprpicker # wlroots-compatible wayland color picker
    pamixer # control audio levels
    playerctl # media player controller
    timg # terminal image viewer
    # swww # wayland wallpaper setter
    inputs.swww.packages.${pkgs.system}.swww
    # swaynotificationcenter # wayland notification daemon
    # mako # wayland notification daemon
    cliphist # clipboard history
    wezterm # terminal
    alejandra # nix formatter
    eww # custom desktop widgets
    htop # system resource monitor
    just # command runner
    cmake # C/C++ build system generator
    ninja # small build system with a focus on speed
    kate # text editor
    julia # scientific programming language
    duf # disk usage viewer
    du-dust # calculate directory sizes. `du` replacement
    eza # `ls` replacement
    tokei # count SLOC in a directory
    hexyl # hex editor
    numbat # scientific units calculator repl
    fd # `find` replacement
    jaq # `jq` replacement
    jd-diff-patch # diff json objects
    jnv # interactive JSON filter using `jq`
    jless # interactive JSON viewer
    jqp # `jq` expr editor
    fx # interactive JSON pager
    yq-go # `jq` but for yaml
    htmlq # `jq` but for html
    bun # javascript runtime and dev tool
    zoxide # intelligent `cd`
    sqlite # sql database in a file
    litecli # A nicer repl for sqlite
    gum # tool to create rich interactive prompts for shell scripts
    fastfetch # a faster neofetch
    onefetch # git repo fetch
    zip
    unzip
    file
    anki # flashcard app
    mpv # media player
    grc # "generic colorizer" improves the output of many commands by adding colors
    bitwarden # password manager
    bitwarden-cli # bitwarden cli
    pass # password manager
    pre-commit # git hook manager
    glow # terminal markdown previewer
    hyperfine # powerful cli benchmark tool
    nickel # configuration language
    nls # nickel language server

    gcc
    gdb
    mold # modern linker
    rustup # rust toolchain manager
    # firefox-devedition

    rclone # rsync for cloud storage
    croc # easily and securely transfer files and folders from one computer to another
    sshx
    gnuplot # plotting utility
    findutils # find, locate
    vulkan-tools # vulkan utilities

    obs-studio # screen recording and streaming

    brotab
    manix
    comma
    fish

    python3
    ouch # {,de}compression tool
    inlyne # markdown viewer
    neovide # neovim gui
    nil # nix lsp
    taplo # toml formatter/linter/lsp
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # https://github.com/hyprwm/hyprpicker/issues/51#issuecomment-2016368757
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  gtk.theme.name = "Adwaita";
  gtk.theme.package = pkgs.gnome.gnome-themes-extra;

  # sourced every time the `julia` is started
  home.file.".julia/config/startup.jl".text = let
    startup-packages = [
      "LinearAlgebra"
      "Statistics"
      "Random"
      # "OhMyREPL"
    ];
  in ''
    ${pkgs.lib.concatStringsSep "\n" (map (pkg: "using ${pkg}") startup-packages)}

    atreplinit() do repl
      println("loaded:")
      for pkg in [${pkgs.lib.concatStringsSep ", " (map (pkg: ''"${pkg}"'') startup-packages)}]
        println(" - $pkg")
      end
    end
  '';

  manual.html.enable = true;
  manual.json.enable = true;
  manual.manpages.enable = true;

  news.display = "notify";

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = null;
  };

  programs.atuin.enable = false;

  # https://alacritty.org/config-alacritty.html
  programs.alacritty = let
    ctrl = "Control";
    super = "Super";
    shift = "Shift";
    alt = "Alt";
    mods = modifiers: join "|" modifiers;
  in {
    enable = true;
    catppuccin.enable = true;
    settings = {
      bell = {duration = 200;};
      cursor = {
        style = {
          blinking = "On";
          shape = "Beam";
        };
        blink_interval = 750; # ms
        unfocused_hollow = true;
      };
      font = {
        builtin_box_drawing = true;
        normal = {
          # family = "JetBrains Mono NFM";
          family = "Iosevka Nerd Font Mono";
          style = "Regular";
        };
        size = 16;
      };
      mouse = {
        hide_when_typing = true;
      };
      hints.enabled = [
        {
          command = "xdg-open";
          hyperlinks = true;
          post_processing = true;
          persist = false;
          # "mouse.enabled" = true;
          binding = {
            key = "u";
            mods = "Control|Shift";
          };
        }
      ];
      keyboard.bindings = let
        as-kv = value: {"${value}" = value;};
        actions = merge (map as-kv ["SearchForward" "CreateNewWindow"]);
        bind = mods': key: action: {
          inherit key action;
          mods = mods mods';
        };
      in [
        # {
        #   key = "f";
        #   mods = mods [ctrl shift];
        #   action = "SearchForward";
        #   # SearchBackward
        # }
        # (bind [ctrl shift] "t" "CreateNewTab")
        (bind [ctrl shift] "f" actions.SearchForward)
        # (bind [ctrl shift] "n" "CreateNewWindow")
        # {
        #   key = "n";
        #   bind = bind [ctrl shift];
        #   chars = "n";
        # }
        (bind [shift] "Escape" "ToggleViMode")
      ];
      live_config_reload = true;
      ipc_socket = true;
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      selection = {save_to_clipboard = true;};
      window = {
        blur = false;
        decorations = "None";
        dynamic_padding = true;
        opacity = 0.9;
        # startup_mode = "Fullscreen";
      };
    };
  };

  programs.bacon = {
    enable = true;
    settings = {
      summary = true;
      wrap = false;
      reverse = true;
      export = {
        enabled = true;
        path = ".bacon-locations";
        line_format = "{kind} {path}:{line}:{column} {message}";
      };
      keybindings = {
        esc = "back";
        s = "toggle-summary";
        w = "toggle-wrap";
        t = "toggle-backtrace";
        q = "quit";
        g = "scroll-to-top";
        shift-g = "scroll-to-bottom";
        c = "job:clippy";
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.bottom = {
    enable = true;
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.btop = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.cava = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.transparent = true;
    settings = {
      general.framerate = 60;
      general.sleep_timer = 3;
      # input.method = "alsa";
      output.method = "noncurses";
      # output.method = "sdl_glsl";
      output.alacritty_sync = 0;
      output.orientation = "bottom";
      smoothing.noise_reduction = 88;
      # color = {
      #   # background = "'#000000'";
      #   # foreground = "'#FFFFFF'";
      #   foreground = "'magenta'";

      #   gradient = 1; # on/off
      #   gradient_count = 8;
      #   gradient_color_1 = "'#59cc33'";
      #   gradient_color_2 = "'#80cc33'";
      #   gradient_color_3 = "'#a6cc33'";
      #   gradient_color_4 = "'#cccc33'";
      #   gradient_color_5 = "'#cca633'";
      #   gradient_color_6 = "'#cc8033'";
      # };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.eww = {
  #   enable = true;
  #   configDir = ./eww;
  # };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    # package = pkgs.firefox-devedition;
  };

  # programs.fish = {
  #   enable = true;
  # };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "${font.monospace}:size=14";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 0.9;
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-eco
      gh-markdown-preview
      # gh-notify
      gh-cal
      # gh-f
      # gh-poi
      gh-actions-cache
      # gh-copilot
      gh-screensaver
    ];

    settings.git_protocol = "https"; # or "ssh"
    settings.aliases = {
      co = "pr checkout";
      conflicts = "diff --name-only --diff-filter=U --relative";
    };
  };

  programs.gh-dash.enable = true;

  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
    extraConfig = {
      init.defaultBranch = "main";
      push.autosetupremote = true;
      # pull.ff = "only";
      pull.rebase = false;
      merge.conflictstyle = "zdiff3";
      # rebase.autostash = true;
      commit.verbose = true;
      merge.tool = "nvimdiff";
      rebase.autosquash = true;
    };

    aliases = {
      unstage = "reset HEAD --";
    };
    attributes = [
      "*.pdf diff=pdf"
    ];
    delta.enable = false;
    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };

    lfs.enable = true;
    ignores = ["**/.envrc" "**/.direnv"];
  };

  programs.git-cliff.enable = true;
  programs.gitui = {
    enable = true;
    catppuccin.enable = true;
  };
  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
    # git:
    #   paging:
    #     externalDiffCommand: difft --color=always --display=inline --syntax-highlight=off
    settings = {
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#using-external-diff-commands
      # git.pagint.externalDiffCommand = "difft --color=always --display=inline --syntax-highlight=off";
      git.pagint.externalDiffCommand = "difft --color=always";
      #   gui.theme = {
      #     lightTheme = true;
      #   };
    };
  };

  # programs.gnome-terminal = {
  #   enable = true;
  #   showMenubar = true;
  #   themeVariant = "system";
  #   profile.default = {
  #     default = true;
  #     allowBold = true;
  #     audibleBell = false;
  #     transparencyPercent = 90;
  #     showScrollbar = true;
  #     font = "Iosevka Nerd Font Mono";
  #   };
  # };

  # programs.gpg.enable = true;

  # TODO: convert
  programs.helix = {
    enable = true;
    # package = pkgs.helix;
    package = inputs.helix.packages.${pkgs.system}.default;
    defaultEditor = true;
    extraPackages = with pkgs;
      [
        marksman
        taplo
      ]
      ++ [
        inputs.simple-completion-language-server.defaultPackage.${pkgs.system}
      ];
    # settings = {
    #   theme = "gruvbox_dark_hard";
    #   editor = {
    #     auto-completion = true;
    #     auto-format = true;
    #     auto-info = true;
    #     auto-pairs = true;
    #     bufferline = "always";
    #     color-modes = true;
    #     completion-replace = true;
    #     completion-trigger-len = 1;
    #     cursor-shape = {
    #       insert = "bar";
    #       normal = "block";
    #       select = "underline";
    #     };
    #     cursorcolumn = false;
    #     cursorline = true;
    #     file-picker = {hidden = false;};
    #     gutters = ["diff" "diagnostics" "line-numbers" "spacer"];
    #     idle-timeout = 400;
    #     indent-guides = {
    #       character = "╎";
    #       render = true;
    #       skip-levels = 1;
    #     };
    #     line-number = "relative";
    #     lsp = {
    #       auto-signature-help = true;
    #       display-inlay-hints = true;
    #       display-messages = true;
    #       display-signature-help-docs = true;
    #       enable = true;
    #       snippets = true;
    #     };
    #     mouse = true;
    #     search = {
    #       smart-case = false;
    #       wrap-around = true;
    #     };
    #     smart-tab = {
    #       enable = true;
    #       supersede-menu = false;
    #     };
    #     soft-wrap = {enable = false;};
    #     statusline = {
    #       center = ["file-name" "file-modification-indicator" "diagnostics"];
    #       left = ["mode" "spinner" "version-control" "separator"];
    #       right = ["separator" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
    #       separator = "│";
    #     };
    #
    #     true-color = true;
    #     undercurl = true;
    #     whitespace = {
    #       characters = {
    #         nbsp = "⍽";
    #         newline = "⏎";
    #         space = "·";
    #         tab = "→";
    #         tabpad = "·";
    #       };
    #       render = {
    #         newline = "none";
    #         space = "none";
    #         tab = "none";
    #       };
    #     };
    #   };
    # };
  };

  # # TODO: get to work
  # accounts.email.accounts.gmail = {
  #   address = "kristoffer.pbs@gmail.com";
  #   realName = "Kristoffer Plagborg Bak Sørensen";
  #   primary = true;
  #   flavor = "gmail.com";
  #   passwordCommand = pkgs.writeScript "email-password" "echo ...";
  #   himalaya.enable = true;
  #   thunderbird.enable = true;
  # };

  programs.himalaya = {
    enable = true;
    settings = {};
  };
  services.himalaya-watch.enable = true;

  programs.jq.enable = true;
  programs.jujutsu.enable = true;

  programs.kakoune.enable = true;

  programs.khal = {
    enable = true;
    locale = let
      monday = 0;
    in {
      weeknumbers = "left";
      unicode_symbols = true;
      firstweekday = monday;
    };
    settings = let
      highlight_event_days = true;
    in
      {
        default = {
          default_calendar = "Calendar";
          timedelta = "5d"; # how many days to show into the future to show events for
          highlight_event_days = highlight_event_days;
          show_all_days = false;
        };
        view = {
          event_view_always_visible = true;
          frame = "top";
        };
      }
      // (
        if highlight_event_days
        then {
          highlight_days = {
            method = "fg";
            multiple = "yellow";
          };
        }
        else {}
      );
  };

  # home.file.".config/kitty/tokyonight-storm.conf".source = ./extra/kitty/tokyonight-storm.conf;
  # home.file.".config/kitty/catppuccin-latte.conf".source = ./extra/kitty/catppuccin-latte.conf;
  # home.file.".config/kitty/catppuccin-macchiato.conf".source = ./extra/kitty/catppuccin-macchiato.conf;
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    environment = {
      # LS_COLORS = "1";
    };
    # font.name = "JetBrainsMono Nerd Font Mono";
    font.name = "Iosevka Nerd Font Mono";
    font.size = 18;
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
      "ctrl+g" = "show_last_command_output";
      "ctrl+shift+up" = "scroll_to_prompt -1";
      "ctrl+shift+down" = "scroll_to_prompt 1";
      "ctrl+shift+h" = "show_scrollback";
      "ctrl+shift+e" = "open_url_with_hints";
      "ctrl+shift+f1" = "show_kitty_doc overview";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "ctrl+home" = "scroll_home";
      "ctrl+end" = "scroll_end";
      f11 = "toggle_fullscreen";
    };
    extraConfig = ''
      # include tokyonight-storm.conf
      # include catppuccin-latte.conf
      # include catppuccin-macchiato.conf
      background_opacity 0.85
      # how much to dim text with the DIM/FAINT escape code attribute
      dim_opacity 0.5

    '';
    settings = {
      allow_remote_control = "yes";
      dynamic_background_opacity = "yes";
      # listen_on =
      disable_ligatures = "never";
      modify_font = "underline_thickness 100%";
      # modify_font = "strikethrough_position 2px";
      undercurl_style = "thick-sparse";

      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      # background_opacity = 0.9;
      strip_trailing_spaces = "smart";
      allow_hyperlinks = "yes";
      url_color = "#0087bd";
      url_style = "curly";
      open_url_with = "default";
      detect_urls = "yes";
      show_hyperlink_targets = "yes";
      underline_hyperlinks = "hover";
      touch_scroll_multiplier = 20;
    };
    shellIntegration.mode = "no-cursor";
    shellIntegration.enableFishIntegration = true;
    shellIntegration.enableBashIntegration = true;
  };

  programs.mpv = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = false;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    extraPackages = with pkgs; [
      gnumake
      tree-sitter
      nodejs # for copilot.lua
      marksman # markdown lsp
      libgit2 # c library to interact with git repositories, needed by fugit2.nvim plugin

      # nice for configuring neovim
      stylua # formatter
      selene # linter
      lua-language-server # lsp
      lua51Packages.lua
      libgit2
      luajit
      luajitPackages.luarocks
    ];
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    # enableBashIntegration = true;
  };

  # programs.nushell.enable = true;
  programs.pandoc.enable = true;
  programs.pet.enable = true;
  # TODO: use catppuccin colors
  programs.ripgrep = {
    enable = true;
    arguments = [
      # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
      "--max-columns=150"
      "--max-columns-preview"
      # Add my 'web' type.
      "--type-add"
      "web:*.{html,css,js}*"
      # Search hidden files/directories by default
      "--hidden"
      # Set the colors.
      "--colors=line:none"
      "--colors=line:style:bold"
      # inputs.catppuccin
      "--smart-case"
    ];
  };

  # home.file.".config/ripgrep/ripgreprc".text = ''

  #   # Search hidden files/directories by default
  #   --hidden

  #   # Set the colors.
  #   --colors=line:none
  #   --colors=line:style:bold

  #   # Because who cares about case!?
  #   --smart-case
  # '';

  # home.sessionVariables.RIPGREP_CONFIG_PATH = home.homeDirectory + "/.config/ripgrep/ripgreprc";

  programs.rio = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      editor = "hx";
      blinking-cursor = false;
      hide-cursor-when-typing = false;
      confirm-before-quit = true;
      use-fork = true; # faster on linux
      window.decorations = "Disabled";
      fonts.family = "Iosevka Nerd Font Mono";
      fonts.size = 16;

      keyboard.use-kitty-keyboard-protocol = false;
      scroll.multiplier = 5.0;
      scroll.divider = 1.0;

      adaptive-theme.light = "belafonte-day";
      adaptive-theme.dark = "belafonte-night";
    };
  };

  programs.rofi = {
    enable = true;
    # catppuccin.enable = true;
  };

  # programs.ruff.enable = true;

  programs.ssh = {
    enable = true;
    compression = true;
  };

  programs.starship = {
    enable = true;
    catppuccin.enable = true;
    enableTransience = true;
    # $\{env_var.AGAIN_ENABLED}
    # $\{env_var.AGAIN_DYNAMIC_ENABLED}
    settings = {
      format = ''$shell$jobs$shlvl$character'';
      right_format = ''$direnv$directory$git_branch$git_commit$git_state$git_metrics$git_status$package$time'';
      add_newline = false;
      git_metrics.disabled = true;
      directory.fish_style_pwd_dir_length = 2;
      shell = {
        disabled = false;
        fish_indicator = "fish";
        nu_indicator = "nu";
        bash_indicator = "bash";
      };
      localip = {
        disabled = false;
        format = "@[$localipv4](bold yellow) ";
        ssh_only = false;
      };
      package = {
        disabled = false;
        symbol = "📦";
        format = "[$symbol$version]($style) ";
      };
      time = {
        disabled = false;
        style = "cyan";
        format = "[$time]($style)";
      };
      shlvl = {
        disabled = true;
        format = "$shlvl level(s) down";
        threshold = 3;
      };
      direnv = {
        disabled = false;
        format = "[$symbol$loaded/$allowed]($style) ";
        style = "bold orange";
      };
      # env_var = {
      #   AGAIN_ENABLED = {
      #     symbol = "◉";
      #     style = "bold fg:red";
      #     default = "";
      #     format = "[$env_value]($style)";
      #     description = "again.fish";
      #     disabled = false;
      #   };
      #   AGAIN_DYNAMIC_ENABLED = {
      #     symbol = "◉";
      #     style = "bold fg:red";
      #     default = "";
      #     format = "[$env_value]($style)";
      #     description = "again.fish";
      #     disabled = false;
      #   };
      #   DIRENV_FILE = {
      #     symbol = " ";
      #     style = "bold fg:cyan";
      #     default = "";
      #     format = "[direnv]($style)";
      #     description = "direnv";
      #     disabled = false;
      #   };
      # };
    };
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = true;
        use_pager = false;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 24;
      };
      style = {
        command_name = {
          bold = true;
          foreground = "yellow";
          italic = false;
          underline = false;
        };
        description = {
          bold = true;
          italic = true;
          underline = false;
        };
        example_code = {
          bold = false;
          foreground = "cyan";
          italic = false;
          underline = false;
        };
        example_text = {
          bold = false;
          foreground = "green";
          italic = false;
          underline = false;
        };
        example_variable = {
          bold = false;
          foreground = "magenta";
          italic = true;
          underline = false;
        };
      };
    };
  };

  # programs.wezterm = {
  #   enable = true;
  # };

  programs.yazi = {
    enable = true;
    catppuccin.enable = true;
    package = inputs.yazi.packages.${pkgs.system}.default;
    settings = {
      manager = {
        ratio = [1 4 3];
        scrolloff = 5;
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_dirs_first = true;
      };
      # which = {sort_by = true;};
    };
    keymap = let
      cd = key: dir: {
        run = "cd ${dir}";
        on = ["g"] ++ (builtins.filter (x: x != "" && x != []) (builtins.split "" key)); # why split function so weird ...
        desc = "Go to ${dir}";
      };
    in {
      manager.prepend_keymap = let
        keymap = {
          keys,
          run,
          desc ? "",
        }: let on = []; in {inherit run desc on;};
      in [
        {
          # FIXME: `--all does not work here`
          run = ''shell "ripdrag --all --and-exit $@" --confirm'';
          on = ["<c-d>"];
          desc = "Open selected files with `ripdrag`";
        }
        {
          run = "arrow 999999999";
          on = ["g" "e"];
          desc = "Move cursor to end";
        }
        {
          run = "help";
          on = ["?"];
          desc = "Open help overview";
        }
        {
          run = "close";
          on = ["q"];
          desc = "Close yazi";
        }
        # (keymap {})
        (cd "m" "~/Music")
        (cd "p" "~/Pictures")
        (cd "v" "~/Videos")
        (cd "." "~/dotfiles")
        (cd "s" "~/Pictures/screenshots")
        (cd "Do" "~/development/own")
        (cd "Df" "~/development/forks")
        (cd "Dc" "~/development/cloned")
      ];
    };
  };

  # TODO: use
  # programs.thunderbird = {
  #   enable = true;
  # };

  # TODO: convert settings to this
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode;
    # package = pkgs.vscode.fhs;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
    extensions = with pkgs.vscode-extensions; [
      zxh404.vscode-proto3
      # tiehuis.zig
      gleam.gleam
      tomoki1207.pdf
      nvarner.typst-lsp
      usernamehw.errorlens
      tamasfe.even-better-toml
      # ms-vscode.cpptools
      llvm-vs-code-extensions.vscode-clangd
      ms-python.python
      # ms-vsliveshare.vsliveshare
      ms-toolsai.jupyter
      yzhang.markdown-all-in-one
      rust-lang.rust-analyzer
      # github.copilot
      # github.copilot-chat
      # tabnine.tabnine-vscode
    ];
    userSettings = {
      "editor.tabSize" = 4;
      "editor.fontSize" = 14;
      "editor.cursorStyle" = "line";
      "editor.fontFamily" = mapjoin ", " (font: "'${font}'") [
        "Iosevka Nerd Font Mono"
        "JetBrainsMono Nerd Font Mono"
        "Droid Sans Mono"
        "monospace"
      ];

      "editor.fontLigatures" = true;

      "editor.formatOnSave" = true;
      "editor.minimap.autohide" = false;
      "editor.minimap.enabled" = true;
      "editor.minimap.side" = "right";
      "editor.wordWrap" = "on";
      "editor.renderWhitespace" = "trailing";
      "editor.mouseWheelZoom" = true;
      "editor.guides.bracketPairs" = true;
      "editor.inlayHints.padding" = true;
      "editor.inlayHints.enabled" = "offUnlessPressed";
      "editor.lineHeight" = 1.25;
      "editor.acceptSuggestionOnEnter" = "smart";
      "editor.suggest.preview" = true;
      "editor.suggest.localityBonus" = true;
      "editor.suggest.showToolbar" = "always";
      "editor.tabCompletion" = "on";
      "explorer.fileNesting.enabled" = true;
      "files.autoSave" = "onWindowChange";
      "files.enableTrash" = true;
      "files.trimFinalNewlines" = true;
      "files.eol" = "\n";
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;

      "workbench.commandPalette.experimental.suggestCommands" = true;
      "workbench.commandPalette.preserveInput" = false;
      "workbench.list.smoothScrolling" = true;

      "workbench.colorTheme" = "Default Dark Modern";

      "workbench.sideBar.location" = "left";
      "workbench.tips.enabled" = true;
      "workbench.tree.indent" = 16;
      "breadcrumbs.enabled" = true;
      "window.titleBarStyle" = "custom";
      "window.autoDetectColorScheme" = true;
      "window.confirmBeforeClose" = "keyboardOnly";
      "telemetry.telemetryLevel" = "off";
      "window.zoomLevel" = 0;
      "github.copilot.enable" = {
        "*" = true;
      };

      "[nix]"."editor.tabSize" = 2;
      "tabnine.experimentalAutoImports" = true;
      "tabnine.debounceMilliseconds" = 1000;
      "jupyter.executionAnalysis.enabled" = true;
      "jupyter.themeMatplotlibPlots" = false;
      "notebook.formatOnCellExecution" = true;
      "notebook.formatOnSave.enabled" = true;
      "notebook.insertFinalNewline" = true;
      "notebook.lineNumbers" = "on";
      "notebook.output.minimalErrorRendering" = false;
    };
    keybindings = let
      ctrl = key: "ctrl+" + key;
      alt = key: "alt+" + key;
      ctrl-alt = key: "ctrl+alt+" + key;
      ctrl-shift = key: "ctrl+shift+" + key;
      keybind = key: command: {inherit key command;};
    in [
      (keybind (ctrl "p") "workbench.action.quickOpen")
      (keybind (ctrl "h") "workbench.action.navigateLeft")
      (keybind (ctrl "l") "workbench.action.navigateRight")
      (keybind (alt "left") "workbench.action.navigateBack")
      (keybind (alt "right") "workbench.action.navigateForward")
      {
        key = ctrl-shift "right";
        command = "editor.action.inlineSuggest.acceptNextLine";
        when = "inlineSuggestionVisible && !editorReadonly";
      }
    ];
  };

  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-thumbnail = true;
      # embed-subs = true;
      # sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    };
  };

  programs.zellij = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.zsh.enable = true;

  # FIXME: does not do anything
  services.darkman = {
    enable = true;
    settings = {
      # lat = 56.15; # Aarhus
      # lon = 10.2; # Aarhus
      portal = true;
      usegeoclue = true;
      dbusserver = true;
    };
    # TODO: change fish color theme
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
      desktop-notification = ''
        ${pkgs.libnotify}/bin/notify-send --app-name="darkman" --urgency=low --icon=weather-clear-night "switching to dark mode"
      '';
      hyprland-wallpaper = ''
        ${pkgs.swww}/bin/swww img ~/Pictures/wallpapers/dark
      '';
    };
    # TODO: change fish color theme
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
      desktop-notification = ''
        ${pkgs.libnotify}/bin/notify-send notify-send --app-name="darkman" --urgency=low --icon=weather-clear "switching to light mode"
      '';
      hyprland-wallpaper = ''
        ${pkgs.swww}/bin/swww img ~/Pictures/wallpapers/light
      '';
    };
  };

  services.dunst = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      global = {
        width = "(200,300)";
        height = 200;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        progress_bar = true;
        # frame_color = "#eceff1";
        font = "JetBrains Nerd Font Mono 10";
      };

      # urgency_normal = {
      #   background = "#37474f";
      #   foreground = "#eceff1";
      #   timeout = 10;
      # };
      # urgency_critical = {
      #   timeout = 0;
      # };
    };
    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.size = "32x32";
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.spotifyd = {
    enable = false;
  };

  # services.espanso = let
  #   espanso-prefix-char = ":";
  #   espanso-match = trigger: replace: {
  #     trigger = espanso-prefix-char + trigger;
  #     replace = replace;
  #   };
  # in {
  #   enable = false;
  #   configs.default = {
  #     backend = "Auto";
  #     auto_restart = true;
  #     show_icon = true;
  #     show_notifications = true;
  #     preserve_clipboard = true;
  #     undo_backspace = true;
  #     toggle_key = "ALT";
  #     search_shortcut = "ALT+SHIFT+ENTER";
  #   };
  #   matches.base.matches = [
  #     (espanso-match "tuta" tutamail)
  #     (espanso-match "gmail" gmail)
  #     (espanso-match "email" email)
  #     (espanso-match "aumail" aumail)
  #     (espanso-match "tf" telephone-number)
  #     (espanso-match "phone" telephone-number)
  #     (espanso-match "name" name)
  #     (espanso-match "fname" full-name)
  #     (espanso-match "addr" "Helsingforsgade 19 st, 4")
  #     (espanso-match "rg" ''
  #       Regards
  #       ${full-name}
  #     '')
  #   ];
  # };

  # xdg-mime query default image/svg+xml
  # xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = let
    loupe = "org.gnome.Loupe.desktop";
    browser = "firefox.desktop";
    image-viewer = loupe;
  in {
    "application/pdf" = ["zathura.desktop" "evince.desktop"];
    "image/svg+xml" = [browser];
    "image/png" = [image-viewer];
    "image/jpeg" = [image-viewer];
    # TODO: create .desktop for `jnv`
    # "application/json" = [jnv];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = "gtk";
      };
    };
    # config.preferred = {
    #   default = "hyprland";
    #   "org.freedesktop.impl.portal.Settings" = "darkman";
    # };
    # config.common.default = "hyprland";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-cosmic
    ];
  };

  # home.file.".config/hypr/bin/hyprland-arise".source = ./target/release/hyprland-arise;

  home.file.".config/xdg-desktop-portal/hyprland-portals.conf".text = ''
    [preferred]
    default=hyprland;gtk
    org.freedesktop.impl.portal.FileChooser=kde
    org.freedesktop.impl.portal.Screencast=kde
  '';

  wayland.windowManager.hyprland = let
    fps = 60;
  in {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [];
    extraConfig = ''
      # exec-once = wl-paste --type text --watch cliphist store #Stores only text data
      # exec-once = wl-paste --type image --watch cliphist store #Stores only image data
      # exec-once = krunner --daemon
      # exec-once = swaync
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      exec-once = swww init &
      exec-once = clipse -listen
      # pkgs.networkmanagerapplet
      # exec-once = nm-applet --indicator &
      exec-once = dunst &
      exec-once = waybar &

      exec-once = hypridle
      # exec-once = copyq
      exec-once = eww daemon &
      exec-once = udiskie &
      exec-once = wlsunset -t 4000 -T 6500 -S 06:30 -s 18:30
      exec-once = wluma &
      # exec-once = ianny &

      windowrule = animation slide left,kitty
      windowrule = animation popin,dolphin
      windowrule = noblur,^(firefox)$ # disables blur for firefox

      windowrulev2 = float, class:(floating) # class for floating windows
      windowrulev2 = tile, class:raylib # to make gbpplanner easier to work with

      windowrulev2 = bordercolor rgb(E54430), class:firefox
      windowrulev2 = bordercolor rgb(4F5BDA), class:WebCord
      windowrulev2 = bordercolor rgb(1BC156), class:Spotify
      windowrulev2 = bordercolor rgb(4A7AAE), class:telegram
      windowrulev2 = bordercolor rgb(FF00FF) rgb(880808),fullscreen:1 # set bordercolor to red if window is fullscreen
      windowrulev2 = bordercolor rgb(FFFF00),title:^(.*Hyprland.*)$ # set bordercolor to yellow when title contains Hyprland
      windowrulev2 = bordercolor rgb(FF0000),title:^(.*YouTube.*)$ # set bordercolor to red when title contains YouTube
      windowrulev2 = bordercolor rgb(E53E00),title:^(.*Reddit.*)$

      monitor = DP-5, 2560x1440@60, 0x0, 1, bitdepth, 10 # acer monitor at home
      # monitor = HDMI-A-1 1920x1080@60, 0x0, 1 # monitor borrowed from RIA
      monitor = eDP-1, 2560x1600@60, 0x1440, 1 # tuxedo laptop

      # monitor=DP-1,2560x1600@60,0x0,1,vrr,1
      # monitor=DP-1,2560x1600@60,0x0,1,bitdepth,10
      # recommended rule for quickly pluggin in random monitors
      # monitor=,preferred,auto,1
      monitor=,highres,auto,1
      # monitor=,highrr,auto,1
    '';
    settings = {
      "$super" = "SUPER";

      bindl = let
        name = "19b7b30";
      in [
        # https://wiki.hyprland.org/Configuring/Binds/#switches
        ",switch:${name}, exec, hyprlock"
      ];
      # mouse bindings
      bindm = [
        "ALT,mouse:272,movewindow"
      ];
      # key bindings
      bind =
        [
          ", f11, fullscreen, 1"
          "SHIFT, f11, fullscreen, 2"
          "CTRL, f11, fullscreen, 0"
          "SUPER, r, layoutmsg, orientationnext"
          "SUPERSHIFT, m, layoutmsg, swapwithmaster"
          "SUPER, space, layoutmsg, swapwithmaster"

          # "focusmonitor"
          # "movecurrentworkspacetomonitor"
          # "swapactiveworkspaces"
          "SUPER, c, movetoworkspace, special"
          "SUPER, q, killactive"

          "SUPERSHIFT, a, exec, anki"
          "SUPER, a, exec, ~/.config/hypr/bin/hyprland-arise --class anki"
          "SUPERSHIFT, f, exec, firefox"
          "SUPER, f, exec, ~/.config/hypr/bin/hyprland-arise --class firefox"

          # "$super, K, exec, wezterm-gui start"
          # "SUPER, k, exec, kitty"
          # "SUPER, k, exec, wezterm-gui start"
          # "SUPER, k, exec, alacritty"
          "SUPER, k, exec, ~/.config/hypr/bin/hyprland-arise --class kitty"
          "SUPERSHIFT, k, exec, kitty"

          "SUPERSHIFT, s, exec, spotify"
          "SUPER, s, exec, ~/.config/hypr/bin/hyprland-arise --class spotify"
          # "SUPER, d, exec, discord"
          "SUPERSHIFT, d, exec, webcord"
          "SUPER, d, exec, ~/.config/hypr/bin/hyprland-arise --class webcord"

          "SUPERSHIFT, m, exec, thunderbird # mail"
          "SUPER, m, exec, ~/.config/hypr/bin/hyprland-arise --class thunderbird"

          "SUPERSHIFT, t, exec, telegram-desktop"
          "SUPER, t, exec, ~/.config/hypr/bin/hyprland-arise --class org.telegram.desktop --exec telegram-desktop"

          "SUPERSHIFT, o, exec, obs # obs-studio"
          "SUPER, o, exec, ~/.config/hypr/bin/hyprland-arise --class com.obsproject.Studio --exec obs"
          "SUPERSHIFT, e, exec, ~/.config/hypr/bind/hyprland-arise --class dolphin"
          "SUPER, e, exec, dolphin"

          "SUPER, p, exec, ~/.config/hypr/bind/hyprland-arise --class okular"
          "SUPERSHIFT, p, exec, okular # pdf"

          "SUPER, z, exec, ~/.config/hypr/bind/hyprland-arise --class Zotero"
          "SUPERSHIFT, z, exec, zotero"

          # bind = SUPER, V, exec,  <terminal name> --class floating -e <shell-env>  -c 'clipse $PPID' # bind the open clipboard operation to a nice key.
          # "ALT, space, exec, krunner"
          # "ALT, space, exec, wofi --show drun"
          "ALT, space, exec, rofi -show drun -show-icons"

          "SUPER, mouse_down, workspace, e-1"
          "SUPER, mouse_up, workspace, e+1"
          # "SUPERSHIFT, f, togglefloating"
          ", xf86audioplay, exec, playerctl play-pause "
          ", xf86audionext, exec, playerctl next"
          ", xf86audioprev, exec, playerctl previous"
          ", xf86audiostop, exec, playerctl stop"
          ", xf86audioraisevolume, exec, pamixer -i 5"
          ", xf86audiolowervolume, exec, pamixer -d 5"

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          "SUPER CTRL,  h, movewindow, l"
          "SUPER CTRL,  l, movewindow, r"
          "SUPER CTRL,  k, movewindow, u"
          "SUPER CTRL,  j, movewindow, d"

          "SUPER CTRL,  left, movewindow, l"
          "SUPER CTRL,  right, movewindow, r"
          "SUPER CTRL,  up, movewindow, u"
          "SUPER CTRL,  down, movewindow, d"

          "SUPERSHIFT, left, resizeactive, -5% 0"
          "SUPERSHIFT, right, resizeactive, 5% 0"
          "SUPERSHIFT, up, resizeactive, 0 -5%"
          "SUPERSHIFT, down, resizeactive, 0 5%"

          "SUPER, Tab, workspace,previous" # cycle recent workspaces
          "ALT, Tab, cyclenext"
          "ALT, Tab, bringactivetotop"
          "SHIFT ALT, Tab, cyclenext, prev"

          # Goto next/previous workspaces
          "SUPER, bracketright, workspace, e+1"
          "SUPER, bracketleft, workspace, e-1"

          ", PRINT, exec, hyprshot -m region"
          "CTRL, PRINT, exec, hyprshot -m window"
          "SHIFT, PRINT, exec, hyprshot -m output" # screenshot a monitor

          # Move/Resize windows with mainMod + LMB/RMB and dragging
          # "bindm = SUPER, mouse:272, movewindow"
          # "bindm = SUPER, mouse:273, resizewindow"
        ]
        # ++ pipe (range 1 10) [builtins.toString (i: "SUPER, ${i}, workspace, ${i}")];
        ++ map (i: let n = builtins.toString i; in "SUPER, ${n}, workspace, ${n}") (range 1 10)
        ++ map (i: let n = builtins.toString i; in "SUPER CTRL, ${n}, movetoworkspace, ${n}") (range 1 10);

      animations = {
        enabled = true;
        first_launch_animation = true;
      };
      # decorations = {
      #   rounding = 10;
      #   blur = {
      #     enabled = true;
      #     size = 3;
      #     passes = 1;
      #   };
      #   drop_shadow = "yes";
      # };
      #
      input = {
        kb_layout = "us,dk";
        kb_options = "grp:win_space_toggle";
        # kb_layout = "us,dk";
        # kb_options = "grp:alt_shift_toggle, caps:swapescape";
        # kb_options = "grp:alt_shift_toggle";
        # https://wiki.hyprland.org/Configuring/Variables/#follow-mouse-cursor
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.0;
          disable_while_typing = true;
          middle_button_emulation = true;
          drag_lock = true;
        };
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 1;
        no_border_on_floating = false;
        layout = "master"; # oneof ["dwindle" "master"]
        resize_on_border = true;
        hover_icon_on_border = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 300; # px
        # workspace_swipe_touch = false;
        workspace_swipe_invert = true;
        workspace_swipe_create_new = true;
      };

      group = {
        groupbar = {
          enabled = true;
        };
      };

      decoration = {
        rounding = 5; # px
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        drop_shadow = true;
        dim_inactive = true;
        dim_strength = 0.1;

        blur = {
          enabled = false;
          passes = 1;
          popups = false;
        };
      };

      master = {
        new_is_master = true;
      };

      misc = {
        disable_hyprland_logo = false;
        disable_splash_rendering = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        focus_on_activate = true;
        # enable_hyprcursor = true;
        # vfr = true;
      };
    };
  };

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = notify-send "lock!"          # dbus/sysd lock command (loginctl lock-session)
        unlock_cmd = notify-send "unlock!"      # same as above, but unlock
        before_sleep_cmd = notify-send "Zzz"    # command ran before sleep
        after_sleep_cmd = notify-send "Awake!"  # command ran after sleep
        ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
    }

    listener {
        timeout = 500                            # in seconds
        on-timeout = notify-send "You are idle!" # command to run when timeout has passed
        on-resume = notify-send "Welcome back!"  # command to run when activity is detected after timeout has fired.
    }
  '';

  # https://github.com/maximbaz/wluma/blob/main/config.toml
  home.file.".config/wluma/config.toml".text = ''
    [als.time]
    thresholds = { 0 = "night", 7 = "dark", 9 = "dim", 11 = "normal", 13 = "bright", 16 = "normal", 18 = "dark", 20 = "night" }

    [[output.backlight]]
    name = "eDP-1"
    path = "/sys/class/backlight/intel_backlight"
    capturer = "wlroots"
  '';

  home.file.".config/io.github.zefr0x.ianny/config.toml".text = ''
    # time is given in seconds
    [timer]
    idle_timeout = 240
    short_break_timeout = 1200
    long_break_timeout = 3840
    short_break_duration = 120
    long_break_duration = 240

    [notification]
    show_progress_bar = true
    minimum_update_delay = 1
  '';

  wayland.windowManager.river = {
    enable = true;
    xwayland.enable = true;
    extraSessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
    settings = {
      map = {
        normal = {
          "Alt Q" = "close";
        };
      };
    };

    extraConfig = ''
      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };

  # home.file.".config/waybar/nix-logo.png".source = ./nix-logo.png;
  # xdg.configFile."waybar-nixos-logo.png".source = ./nixos-logo.png;

  programs.waybar = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.mode = "prependImport";
    systemd.enable = true;
    settings = let
      height = 24;
    in {
      mainbar = {
        layer = "top";
        position = "top";
        spacing = 4; # px
        inherit height;
        output = builtins.attrValues monitors;
        # margin-top = 5;
        # margin-bottom = 5;
        modules-left = [
          # "systemd-failed-units"
          # "keyboard-state"
          "image#nixos-logo"
          "backlight"
          "pulseaudio"
          # "wireplumber"
          # "pulseaudio/slider"
          "mpris"
          "image/spotify-cover-art"
          # "cava" # FIXME: get to work
        ];
        modules-center = [
          # "wlr/taskbar"
          "tray"
          "clock"
          "privacy"
        ];
        modules-right = [
          "power-profiles-daemon"
          # "idle_inhibitor"
          "battery"
          "disk"
          "memory"
          # "load"
          "cpu"
          # "custom/gpu-usage"
          "temperature"
          "bluetooth"
          "network"
        ];
        battery = {
          format = "{capacity}% {icon} ";
          format-icons = ["" "" "" "" ""];
        };
        memory = {
          interval = 30;
          format = "{used:0.1f}GiB / {total:0.1f}GiB  ";
          # on-click = "btop";
          on-click = "${terminal} ${pkgs.lib.getExe pkgs.btop}";
          states = {
            warning = 70; # percent
            critical = 95; # percent
          };
        };
        systemd-failed-units = {
          hide-on-ok = false;
          format = "systemd ✗ {nr_failed}";
          format-ok = "✓";
          system = true;
          user = true;
        };
        clock = {
          interval = 60;
          format = "{:%H:%M} ";
          format-alt = "{:%A; %B %d; %Y (%R)}  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        pulseaudio = {
          format = "{volume}% {icon} ";
          format-bluetooth = "{volume}% {icon} ";
          format-muted = "";
          format-icons = {
            # "alsa_output.pci-0000_00_1f.3.analog-stereo"= "";
            # "alsa_output.pci-0000_00_1f.3.analog-stereo-muted"= "";
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = ["Easy Effects Sink"];
        };
        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };
        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "";
          on-click = "helvum";
          format-icons = ["" "" ""];
        };

        network = {
          # "interface"= "wlp2s0";
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ipaddr}/{cidr} 󰊗 ";
          format-disconnected = ""; # An empty format will hide the module.
          tooltip-format = "{ifname} via {gwaddr} 󰊗 ";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
          tooltip-format-ethernet = "{ifname}  ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "nmtui";
        };

        mpris = {
          # "format"= "{player_icon}  <b>{dynamic}</b>";
          # "format-paused"= "{status_icon}  <i>{dynamic}</i>";
          format = "{player_icon}  <b>{title} - {artist} - ({length})</b>";
          format-paused = "{player_icon}  <i>{title} - {artist} - ({length})</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
            spotify = "";
            youtube = "";
          };
          status-icons = {
            paused = "⏸";
            playing = "▶";
          };
          # "ignored-players"= ["firefox"]
        };

        power-profiles-daemon = {
          format = "{icon}   {profile}";
          tooltip-format = "Power profile= {profile}\nDriver= {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        cpu = {
          interval = 5;
          tooltip = false;
          on-click = "${terminal} ${pkgs.lib.getExe pkgs.btop}";
          format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
          format-icons = [
            "<span color='#69ff94'>▁</span>" # green
            "<span color='#2aa9ff'>▂</span>" # blue
            "<span color='#f8f8f2'>▃</span>" # white
            "<span color='#f8f8f2'>▄</span>" # white
            "<span color='#ffffa5'>▅</span>" # yellow
            "<span color='#ffffa5'>▆</span>" # yellow
            "<span color='#ff9977'>▇</span>" # orange
            "<span color='#dd532e'>█</span>" # red
          ];
        };

        tray = {
          icon-size = 16;
          spacing = 10;
        };
        privacy = {
          icon-spacing = 4;
          icon-size = 18;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };

        temperature = {
          # thermal-zone = 2;
          # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          # critical-threshold = 80;
          # format-critical = "{temperatureC}°C ";
          format = "{temperatureC}°C ";
        };

        disk = {
          interval = 60;
          format = " {used} / {total}";
          path = "/";
        };
        # https=//www.nerdfonts.com/cheat-sheet?q=moon
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" "" "" ""];
        };

        # FIXME: still not work
        "image/spotify-cover-art" = {
          # TODO
          exec = pkgs.lib.getExe scripts.spotify-cover-art;
          # exec = "spotify-cover-art";
          # "exec"= "bash -c 'spotify-cover-art'";
          # // "exec"="~/.config/waybar/custom/spotify/album_art.sh";
          size = height;
          interval = 30;
        };

        # "group/group-power" = {
        #   orientation = "inerit";
        #   drawer = {
        #     transition-duration = 500;
        #     children-class = "not-power";
        #     transition-left-to-right = false;
        #   };
        #   modules = [
        #     "custom/power"
        #     "custom/quit"
        #     "custom/lock"
        #     "custom/reboot"
        #   ];
        # };

        # "custom/quit" = {
        #   format = "󰗼";
        #   tooltip = false;
        #   on-click = "hyprctl dispatch exit";
        # };
        # "custom/lock" = {
        #   format = "󰍁";
        #   tooltip = false;
        #   on-click = "swaylock";
        # };
        # "custom/reboot" = {
        #   format = "󰜉";
        #   tooltip = false;
        #   on-click = "systemctl reboot";
        # };

        # "custom/power" = {
        #   format = "";
        #   tooltip = false;
        #   on-click = "shutdown now";
        # };
        "image#nixos-logo" = {
          path = home.homeDirectory + "/.config/waybar/nixos-logo.png";
          size = 32;
          # interval = 60 * 60 * 24;
          on-click = "${pkgs.xdg-utils}/bin/xdg-open 'https://nixos.org/'";
          tooltip = true;
        };
      };
    };
    style =
      /*
      css
      */
      ''
                        * {
                            /* border: none; */
                            border-radius: 5px;
                            /* padding: 2px 0px; */
                            font-family: Font Awesome, Roboto, Arial, sans-serif;
                            font-size: 16px;
                            color: @text;
                            /* color: #ffffff; */
                            /* min-height: 0; */
                        }

                        window#waybar {
                            font-family: FontAwesome, monospace;
                            background-color: transparent;
                            border-bottom: 0px;
                            color: #ebdbb2;
                            transition-property: background-color;
                            transition-duration: .5s;
                        }

                        window#waybar.hidden {
                            opacity: 0.2;
                        }

                        window#waybar.empty #window {
                            background-color: transparent;
                        }

                        .modules-right {
                            margin: 10px 10px 0 0;
                        }
                        .modules-center {
                            margin: 10px 0 0 0;
                        }
                        .modules-left {
                            margin: 10px 0 0 10px;
                        }

                        button {
                            border: none;
                        }

                        #tray menu {
                            font-family: sans-serif;
                        }

                        tooltip {
                          background: rgba(43, 48, 59, 0.5);
                          border: 1px solid rgba(100, 114, 125, 0.5);
                        }
                        tooltip label {
                          color: white;
                        }

                        #workspaces button {
                            padding: 0 5px;
                            background: transparent;
                            color: white;
                            border-bottom: 3px solid transparent;
                        }

                        #workspaces button.focused {
                            background: #64727D;
                            border-bottom: 3px solid white;
                        }

                        /* #mode, #clock, #battery #keyboard-state { */
                            /* padding: 2px 6px; */
                            /* border-radius: 25%; */
                        /* } */

                        /* #clock, */
                        /* #battery, */
                        /* #cpu, */
                        /* #memory, */
                        /* #temperature, */
                        /* #network, */
                        /* #pulseaudio, */
                        /* #custom-media, */
                        /* #tray, */
                        /* #mode, */
                        /* #custom-power, */
                        /* #custom-menu, */
                        /* #idle_inhibitor { */
                            /* padding: 0 10px; */
                        /* } */


                        #idle_inhibitor,
                        #cava,
                        #scratchpad,
                        #mode,
                        #window,
                        #clock,
                        #battery,
                        #backlight,
                        #wireplumber,
                        #tray,
                        #privacy,
                        #temperature,
                        #mpris,
                        #bluetooth,
                        #power-profiles-daemon,
                        #pulseaudio,
                        #pulseaudio-slider,
                        #memory,
                        #disk,
                        #cpu,
                        /* #custom-gpu-usage, */
                        #network,
                        #taskbar,
                        #load {
                            padding: 8px 10px;
                            /* background-color: #282828; */
                            background-color: alpha(@mantle, 0.75);
                        /* #191C19 */
                            color: @text;
                        }


                        #battery.charging, #battery.plugged {
                            background-color: #98971a;
                            color: #282828;
                        }

                        #mpris.playing {
                            background-color: @green;
                        }

                        #mpris.paused {
                            background-color: rgba(80, 80, 80, 0.5);
                        }

                        #mpris.stopped {
                            background-color: @red;
                        }

                        #mpris.spotify {
                            background-color: #20D465;
                            color: black;
                        }

                        /* #mpris.youtube { */
                        #mpris.firefox {
                            background-color: #FB0B08;
                            color: black;
                        }

                        label:focus {
                            background-color: #000000;
                        }

                        #bluetooth.on {
                          background-color: @teal;
                        }

        /*    bluetooth */
        /*    bluetooth.disabled */
        /*    bluetooth.off */
        /*    bluetooth.on */
        /*    bluetooth.connected */
        /*    bluetooth.discoverable */
        /*    bluetooth.discovering */
        /*    bluetooth.pairable */



                        #tray > .passive {
                            -gtk-icon-effect: dim;
                        }

                        #tray > .needs-attention {
                            -gtk-icon-effect: highlight;
                        }

                        #mode {
                            background-color: #689d6a;
                            color: #282828;
                            /* box-shadow: inset 0 -3px #ffffff; */
                        }

                        /* #mode { */
                            /* background: #64727D; */
                            /* border-bottom: 3px solid white; */
                        /* } */

                        /* #clock { */
                            /* background-color: #64727D; */
                        /* } */

                        /* #battery { */
                            /* background-color: #ffffff; */
                            /* color: black; */
                        /* } */

                        /* #battery.charging { */
                            /* color: white; */
                            /* background-color: #26A65B; */
                        /* } */

                        /* @keyframes blink { */
                            /* to { */
                                /* background-color: #ffffff; */
                                /* color: black; */
                            /* } */
                        /* } */

                        #battery.warning:not(.charging) {
                            background: #f53c3c;
                            color: white;
                            animation-name: blink;
                            animation-duration: 0.5s;
                            animation-timing-function: steps(12);
                            animation-iteration-count: infinite;
                            animation-direction: alternate;
                        }

                        /* #systemd-failed-units { */
                          /* color: red; */
                        /* } */

                        /* #systemd-failed-units.ok { */
                          /* color: green; */
                        /* } */

                        /* #keyboard-state { */

                        /* } */

                        /* #bluetooth.on { */
                            /* color: green; */
                        /* } */

                        /* #bluetooth.off { */
                            /* color: red; */
                        /* } */


                        /* #bluetooth */
                        /* #bluetooth.disabled */
                        /* #bluetooth.off */
                        /* #bluetooth.on */
                        /* #bluetooth.connected */
                        /* #bluetooth.discoverable */
                        /* #bluetooth.discovering */
                        /* #bluetooth.pairable */

                        #network.disabled {
                            color: @mauve;
                        }

                        #network.enabled {
                            color: @green;
                        }


                        /* #network */
                        /* #network.disabled */
                        /* #network.disconnected */
                        /* #network.linked */
                        /* #network.ethernet */
                        /* #network.wifi */

                #power-profiles-daemon {
                    color: @crust;
                }

                #power-profiles-daemon.performance {
                    background-color: @red;
                }

                #power-profiles-daemon.balanced {
                    background-color: @peach;
                }

                #power-profiles-daemon.power-saver {
                    background-color: @green;
                }

                #power-profiles-daemon.default {
                    background-color: @sky;
                }



                        /* #pulseaudio */
                        /* #pulseaudio.bluetooth */
                        /* #pulseaudio.muted */
                        /* #pulseaudio.source-muted */

                        /* #pulseaudio-slider slider { */
                            /* min-height: 0px; */
                            /* min-width: 0px; */
                            /* opacity: 0; */
                            /* background-image: none; */
                            /* border: none; */
                            /* box-shadow: none; */
                        /* } */
                        /* #pulseaudio-slider trough { */
                            /* min-height: 80px; */
                            /* min-width: 10px; */
                            /* border-radius: 5px; */
                            /* background-color: black; */
                        /* } */
                        /* #pulseaudio-slider highlight { */
                            /* min-width: 10px; */
                            /* border-radius: 5px; */
                            /* background-color: green; */
                        /* } */


                        /* #network */
                        /* #network.disabled */
                        /* #network.disconnected */
                        /* #network.linked */
                        /* #network.ethernet */
                        /* #network.wifi */

                        #temperature.critical {
                            background-color: @red;
                            color: @crust;
                        }

                        #memory.warning { background-color: @flamingo; }
                        #memory.critical { background-color: @red; }


      '';
  };

  # TODO: create and submit a home-manager module for this
  # TODO: install some .thThemes and .sublime-syntax
  home.file.".config/the-way/config.toml".text = ''
    theme = 'base16-ocean.dark'
    # db_dir = 'the_way_db'
    db_dir = '${cache_dir}/the-way/the_way_db'
    themes_dir '${data_dir}/the-way/themes'
    # themes_dir = 'the_way_themes'
    # copy_cmd = 'xclip -in -selection clipboard'
    copy_cmd = 'wl-copy --trim-newline'
  '';

  # https://haseebmajid.dev/posts/2023-07-25-nixos-kanshi-and-hyprland/
  # "eDP-1" is laptop screen
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
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

  services.network-manager-applet.enable = true;

  programs.zathura = {
    enable = true;
    mappings = {
      "" = "navigate next";
      # D = "toggle_page_mode";
      "[fullscreen] " = "zoom in";
    };
    extraConfig = ''
      set selection-clipboard clipboard
      map D set "first-page-column 1:1"
      map <C-d> set "first-page-column 1:2"
      map ge bottom
    '';
  };

  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
      "screen_down" = ["d" ""];
      "screen_up" = ["u" ""];
    };
    config = {
    };
  };

  # TODO: save path as a let binding to use in niri config
  home.file.".local/share/bluetoothctl/init-script".text = ''
    devices
    list
    scan on
  '';

  programs.niri = {
    enable = true;
    settings = {
      input.keyboard.xkb = {
        layout = "us,dk";
        # options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
        options = "compose:ralt,ctrl:nocaps";
      };
      input.focus-follows-mouse = true;
      input.touchpad.dwt = true;
      input.warp-mouse-to-focus = true;
      prefer-no-csd = true;
      environment = {
        QT_QPA_PLATFORM = "wayland";
        DISPLAY = null;
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };

      layout = {
        gaps = 10; # px
        # center-focused-column = "on-overflow";
        center-focused-column = "never";
        # center-focused-column = "always";
        preset-column-widths = [
          {proportion = 1.0 / 3.0;}
          {proportion = 1.0 / 2.0;}
          {proportion = 2.0 / 3.0;}
        ];
        # default-column-width = {proportion = 1.0 / 3.0;};
        default-column-width = {proportion = 1.0 / 2.0;};
        focus-ring = {
          enable = true;
          width = 4;
          active.gradient = {
            from = "#80c8ff";
            to = "#d3549a";
            angle = 45;
          };
        };
      };
      screenshot-path = "~/Pictures/screenshots/screenshot-%Y-%m-%d %H-%M-%S.png";
      window-rules = [
        {
          draw-border-with-background = false;
          # draw each corner as rounded with the same radius
          geometry-corner-radius = let
            r = 8.0;
          in {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
          clip-to-geometry = true;
        }
        {
          # dim unfocused windows
          matches = [{is-focused = false;}];
          opacity = 0.95;
        }
        {
          # FIXME: does not match private browsing in firefox
          matches = [
            {
              app-id = "^firefox$";
              title = "Private Browsing";
            }
          ];
          border.active.color = "purple";
        }
      ];

      outputs.${monitors.laptop} = {
        position.y = 1440;
        position.x = 0;
        scale = 1.0;
      };
      outputs.${monitors.acer} = {
        scale = 1.0;
        position.x = 0;
        position.y = 0;
      };

      spawn-at-startup = map (s: {command = pkgs.lib.strings.splitString " " s;}) [
        "swww-daemon"
        "waybar"
        "kitty"
        # "spotify"
        "telegram-desktop"
        "udiskie"
        "dunst"
        # "eww daemon"
        # "eww ~/.config/eww/bar open bar" # FIX: not always open, and i want on multiple monitors
        "wlsunset -t 4000 -T 6500 -S 06:30 -s 18:30"
        "wluma"
        "copyq"
      ];

      # https://github.com/sodiboo/nix-config/blob/3d25eaf71cc27a0159fd3449c9d20ac4a8a873b5/niri.mod.nix#L196C11-L232C14
      animations.shaders.window-resize = ''
        vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
            vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

            vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
            vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

            // We can crop if the current window size is smaller than the next window
            // size. One way to tell is by comparing to 1.0 the X and Y scaling
            // coefficients in the current-to-next transformation matrix.
            bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
            bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

            vec3 coords = coords_stretch;
            if (can_crop_by_x)
                coords.x = coords_crop.x;
            if (can_crop_by_y)
                coords.y = coords_crop.y;

            vec4 color = texture2D(niri_tex_next, coords.st);

            // However, when we crop, we also want to crop out anything outside the
            // current geometry. This is because the area of the shader is unspecified
            // and usually bigger than the current geometry, so if we don't fill pixels
            // outside with transparency, the texture will leak out.
            //
            // When stretching, this is not an issue because the area outside will
            // correspond to client-side decoration shadows, which are already supposed
            // to be outside.
            if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                color = vec4(0.0);
            if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                color = vec4(0.0);

            return color;
        }
      '';

      # https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettingsbinds
      binds = with config.lib.niri.actions; let
        sh = spawn "sh" "-c";
        fish = spawn "fish" "--no-config" "-c";
        nu = spawn "nu" "-c";
        playerctl = spawn "playerctl";
        brightnessctl = spawn "brightnessctl";
        wpctl = spawn "wpctl"; # wireplumber
        bluetoothctl = spawn "bluetoothctl";
        run-flatpak = spawn "flatpak" "run";
        run-in-terminal = spawn "kitty";
        run-in-sh-within-kitty = spawn "kitty" "sh" "-c";
        # focus-workspace-keybinds = builtins.listToAttrs (map:
        #   (n: {
        #     name = "Mod+${toString n}";
        #     value = {action = "focus-workspace ${toString n}";};
        #   }) (range 1 10));
      in {
        "XF86AudioRaiseVolume".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        "XF86AudioLowerVolume".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
        "XF86AudioMute" = {
          action = wpctl "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action = wpctl "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          allow-when-locked = true;
        };

        "Mod+TouchpadScrollDown".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+";
        "Mod+TouchpadScrollUp".action = wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-";

        "XF86AudioPlay".action = playerctl "play-pause";
        "XF86AudioNext".action = playerctl "next";
        "XF86AudioPrev".action = playerctl "previous";
        "XF86AudioStop".action = playerctl "stop";
        "XF86MonBrightnessUp".action = brightnessctl "set" "10%+";
        "XF86MonBrightnessDown".action = brightnessctl "set" "10%-";
        "Mod+Shift+TouchpadScrollDown".action = brightnessctl "set" "5%+";
        "Mod+Shift+TouchpadScrollUp".action = brightnessctl "set" "5%-";

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        # inherit (focus-workspace-keybinds) ${builtins.attrNames focus-workspace-keybinds};

        # "Mod+?".action = show-hotkey-overlay;
        "Mod+T".action = spawn "kitty";
        "Mod+F".action = spawn "firefox";
        "Mod+G".action = spawn "telegram-desktop";
        "Mod+S".action = spawn "spotify";
        "Mod+D".action = spawn "webcord";
        # "Mod+E".action = run-in-kitty "yazi";
        "Mod+E".action = run-in-sh-within-kitty "cd ~/Downloads; yazi";
        # "Mod+E".action = spawn "dolphin";
        # "Mod+B".action = spawn "overskride";
        "Mod+B".action = run-in-terminal (pkgs.lib.getExe scripts.bluetoothctl-startup);
        # "Mod+B".action = run-in-terminal "bluetoothctl" "--init-script" "/home/${username}/.local/share/bluetoothctl/init-script";

        # (pkgs.lib.getExe bluetoothctl-init-script);
        "f11".action = fullscreen-window;
        "Mod+f11".action = spawn (pkgs.lib.getExe scripts.wb-toggle-visibility);

        # "Mod+Shift+E".action = quit;
        # "Mod+Ctrl+Shift+E".action = quit {skip-confirmation = true;};

        "Mod+Plus".action = set-column-width "+10%";
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Down".action = move-window-down;

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+J".action = move-window-down;

        # TODO:
        #       Mod+Home { focus-column-first; }
        # Mod+End  { focus-column-last; }
        # Mod+Ctrl+Home { move-column-to-first; }
        # Mod+Ctrl+End  { move-column-to-last; }
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;

        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "Mod+Q".action = close-window;
        "Mod+V".action = spawn "copyq" "menu";
        "Mod+M".action = maximize-column;

        # // There are also commands that consume or expel a single window to the side.
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        # Mod+R { switch-preset-column-width; }
        # Mod+Shift+R { reset-window-height; }

        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = reset-window-height;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        # // Actions to switch layouts.
        #    // Note: if you uncomment these, make sure you do NOT have
        #    // a matching layout switch hotkey configured in xkb options above.
        #    // Having both at once on the same hotkey will break the switching,
        #    // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
        # // Mod+Space       { switch-layout "next"; }
        # // Mod+Shift+Space { switch-layout "prev"; }

        "Mod+Space".action = switch-layout "next";
        "Mod+Shift+Space".action = switch-layout "prev";

        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;

        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;

        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        # // Switches focus between the current and the previous workspace.
        "Mod+Tab".action = focus-workspace-previous;
        # "Mod+Return".action = spawn "anyrun";
        # "Mod+Return".action = fish "pidof anyrun; and pkill anyrun; or anyrun";
        "Mod+Return".action = fish "pidof nwg-drawer; and pkill nwg-drawer; or nwg-drawer -ovl -fm dolphin";

        "Mod+Shift+P".action = power-off-monitors;
      };
    };
    # // focus-workspace-keybinds;
  };

  # FIX
  # home.file.".config/fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
  # home.file.".config/fastfetch/config.jsonc".source = ./fastfetch.config.jsonc;
  # home.file.".config/fastfetch/config.jsonc".source = ./foo;

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        # ./some_plugin.so
        # "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
      ];
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      width = {fraction = 0.3;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      # layer = "top";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 10;
    };
    # extraCss = ''
    #   .some_class {
    #     background: red;
    #   }
    # '';
    # FIXME: `osConfig` not found
    # extraConfigFiles."nixos-options.ron".text = let
    #   #               ↓ home-manager refers to the nixos configuration as osConfig
    #   nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
    #   # merge your options
    #   options = builtins.toJSON {
    #     ":nix" = [nixos-options];
    #   };
    #   # or alternatively if you wish to read any other documentation options, such as home-manager
    #   # get the docs-json package from the home-manager flake
    #   # hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
    #   # options = builtins.toJSON {
    #   #   ":nix" = [nixos-options];
    #   #   ":hm" = [hm-options];
    #   #   ":something-else" = [some-other-option];
    #   #   ":nall" = [nixos-options hm-options some-other-option];
    #   # };
    # in ''
    #   Config(
    #       // add your option paths
    #       options: ${options},
    #    )
    # '';

    # extraConfigFiles."some-plugin.ron".text = ''
    #   Config(
    #     // for any other plugin
    #     // this file will be put in ~/.config/anyrun/some-plugin.ron
    #     // refer to docs of xdg.configFile for available options
    #   )
    # '';
  };

  # TODO: get to work
  # TODO: create dns alias
  services.glance.enable = true;
  services.glance.settings = {
    server.port = 5678;
    server.host = "localhost";
    pages = [
      {
        columns = [
          {
            size = "small";
            widgets = [
              {type = "calendar";}
              {
                cache = "3h";
                collapse-after = 3;
                feeds = [
                  {url = "https://ciechanow.ski/atom.xml";}
                  {
                    title = "Josh Comeau";
                    url = "https://www.joshwcomeau.com/rss.xml";
                  }
                  {url = "https://samwho.dev/rss.xml";}
                  {url = "https://awesomekling.github.io/feed.xml";}
                  {
                    title = "Ahmad Shadeed";
                    url = "https://ishadeed.com/feed.xml";
                  }
                ];
                limit = 10;
                type = "rss";
              }
              {
                channels = ["theprimeagen" "cohhcarnage" "christitustech" "blurbs" "asmongold" "jembawls"];
                type = "twitch-channels";
              }
            ];
          }
          {
            size = "full";
            widgets = [
              {type = "hacker-news";}
              {
                channels = ["UCR-DXc1voovS8nhAvccRZhg" "UCv6J_jJa8GJqFwQNgNrMuww" "UCOk-gHyjcWZNj3Br4oxwh0A"];
                type = "videos";
              }
              {
                subreddit = "selfhosted";
                type = "reddit";
              }
            ];
          }
          {
            size = "small";
            widgets = [
              {
                location = "Aarhus, Denmark";
                type = "weather";
              }
              {
                markets = let
                  ticker = name: symbol: {inherit name symbol;};
                in [
                  (ticker "S&P 500" "SPY")
                  (ticker "NVIDIA" "NVDA")
                  (ticker "Apple" "AAPL")
                  (ticker "Bitcoin" "BTC-USD")
                  (ticker "Microsoft" "MSFT")
                  (ticker "Google" "GOOGL")
                  (ticker "AMD" "AMD")
                  (ticker "Reddit" "RDDT")
                ];
                type = "markets";
              }
            ];
          }
        ];
        name = "Home";
      }
    ];
  };
}
