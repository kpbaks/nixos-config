{
  config,
  pkgs,
  ...
}: let
  name = "Kristoffer Sørensen";
  full-name = "Kristoffer Plagborg Bak Sørensen";
  username = "kpbaks";
  gmail = "kristoffer.pbs@gmail.com";
  aumail = "201908140@post.au.dk";
  tutamail = "kristoffer.pbs@tuta.io";
  email = gmail;
  telephone-number = "21750049";
  system = "x86_64-linux";
  lib = pkgs.lib;
  join = lib.strings.concatStringsSep;
  mapjoin = lib.strings.concatMapStringsSep;
  range = from: to: builtins.genList (i: from + i) (to - from);
  pipe = lib.pipe;
  tostring = builtins.toString;
  merge = list: builtins.foldl' (acc: it: acc // it) {} list;
in rec {
  # TODO: consider using https://github.com/chessai/nix-std
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

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

  home.username = username;
  home.homeDirectory = "/home/" + username;

  # TODO: sync with `configuration.nix`
  home.stateVersion = "23.11";

  # TODO: document all pkgs

  home.packages = with pkgs; [
    tabnine
    waybar
    # grit
    d2
    graphviz
    aria
    networkmanagerapplet
    wofi
    rofi-wayland
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
    discord
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
    swww # wayland wallpaper setter
    # swaynotificationcenter # wayland notification daemon
    # mako # wayland notification daemon
    cliphist # clipboard history
    wezterm # terminal
    kitty # terminal
    alacritty # terminal
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
    jqp # `jq` expr editor
    fx # interactive JSON pager
    yq-go # `jq` but for yaml
    htmlq # `jq` but for html
    bun # javascript runtime and dev tool
    zoxide # intelligent `cd`
    sqlite # sql database in a file
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

    python3
    ouch # {,de}compression tool
    inlyne # markdown viewer
    # neovide # neovim gui
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

  # sourced every time the `julia` is started
  # home.file.".julia/config/startup.jl".source = ./startup.jl;
  home.file.".julia/config/startup.jl".text = let
    startup-packages = [
      "LinearAlgebra"
      "Statistics"
      "Random"
      # "OhMyREPL"
    ];
  in ''
    using LinearAlgebra
    using Statistics
    using Random
    # using OhMyREPL # `Pkg.add("OhMyREPL")`

    atreplinit() do repl
    	println("loaded:")
        for pkg in ["LinearAlgebra", "Statistics", "Random"]
            println(" -	$pkg")
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

  # programs.atuin = {
  #   enable = true;
  # };

  # https://alacritty.org/config-alacritty.html
  programs.alacritty = let
    ctrl = "Control";
    super = "Super";
    shift = "Shift";
    alt = "Alt";
    mods = modifiers: join "|" modifiers;
  in {
    enable = true;
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
  };

  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      general.sleep_timer = 3;
      # input.method = "alsa";
      output.method = "noncurses";
      # output.method = "sdl_glsl";
      output.alacritty_sync = 0;
      output.orientation = "bottom";
      smoothing.noise_reduction = 88;
      color = {
        # background = "'#000000'";
        # foreground = "'#FFFFFF'";
        foreground = "'magenta'";

        gradient = 1; # on/off
        gradient_count = 8;
        gradient_color_1 = "'#59cc33'";
        gradient_color_2 = "'#80cc33'";
        gradient_color_3 = "'#a6cc33'";
        gradient_color_4 = "'#cccc33'";
        gradient_color_5 = "'#cca633'";
        gradient_color_6 = "'#cc8033'";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.eww = {
  #   enable = true;
  #   configDir = home.homeDirectory + "/.config/eww";
  # };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    # package = pkgs.firefox-devedition;
  };

  # programs.fish = {
  #   enable = true;
  # };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.aliases = {
      co = "pr checkout";
    };
  };

  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
    extraConfig = {
      init.defaultBranch = "main";
      push.autosetupremote = true;
      pull.ff = "only";
      merge.conflictstyle = "zdiff3";
      # rebase.autostash = true;
      commit.verbose = true;
      merge.tool = "nvimdiff";
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
  };

  programs.git-cliff.enable = true;
  programs.gitui.enable = true;

  # programs.gpg.enable = true;

  # TODO: convert
  programs.helix = {
    enable = true;
    # package = pkgs.helix;
    # https://discourse.nixos.org/t/home-manager-helix-editor-install-helix-using-flake/40503/6
    package = (builtins.getFlake "github:helix-editor/helix").packages.${pkgs.system}.default;
    defaultEditor = true;
    extraPackages = with pkgs; [
      marksman
      taplo
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

  programs.himalaya = {
    enable = true;
  };
  # services.himalaya-watch = {
  #   enable = true;
  # };

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

  home.file.".config/kitty/tokyonight-storm.conf".source = ./extra/kitty/tokyonight-storm.conf;
  programs.kitty = {
    enable = true;
    environment = {
      # LS_COLORS = "1";
    };
    # font.name = "JetBrainsMono Nerd Font Mono";
    font.name = "Iosevka Nerd Font Mono";
    font.size = 14;
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
      f11 = "toggle_fullscreen";
    };
    extraConfig = ''
      include tokyonight-storm.conf
      background_opacity 0.9
    '';
    settings = {
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
  };

  programs.neovim = {
    enable = true;
    defaultEditor = false;
    package = pkgs.neovim-nightly;
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
    ];
  };

  programs.nix-index.enable = true;

  # programs.nushell.enable = true;
  programs.pandoc.enable = true;
  programs.pet.enable = true;
  programs.ripgrep.enable = true;

  # programs.ruff.enable = true;

  programs.ssh = {
    enable = true;
    compression = true;
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
    settings = {
      manager = {
        ratio = [1 4 3];
        scrolloff = 5;
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_dirs_first = true;
      };
      which = {sort_by = true;};
    };
  };

  # programs.thunderbird = {
  #   enable = true;
  # };

  # TODO: convert settings to this
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    # package = pkgs.vscode.fhs;
    # package = pkgs.vscodium;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
    extensions = with pkgs.vscode-extensions; [
      usernamehw.errorlens
      tamasfe.even-better-toml
      ms-vscode.cpptools
      llvm-vs-code-extensions.vscode-clangd
      ms-python.python
      ms-vsliveshare.vsliveshare
      ms-toolsai.jupyter
      yzhang.markdown-all-in-one
      rust-lang.rust-analyzer
      github.copilot
      github.copilot-chat
      tabnine.tabnine-vscode
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

      "editor.formatOnSave" = false;
      "editor.minimap.autohide" = false;
      "editor.minimap.enabled" = false;
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
      "files.trimTrailingWhitespace" = false;

      "workbench.commandPalette.experimental.suggestCommands" = false;
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
  };

  programs.zoxide = {
    enable = true;
  };

  services.darkman = {
    enable = true;
    settings = {
      lat = 56.15; # Aarhus
      lon = 10.2; # Aarhus
      portal = true;
      usegeoclue = false;
      dbusserver = true;
    };
    darkModeScripts = {};
    lightModeScripts = {};
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = "(200,300)";
        height = 200;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        progress_bar = true;
        frame_color = "#eceff1";
        font = "JetBrains Nerd Font Mono 10";
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
      urgency_critical = {
        timeout = 0;
      };
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

  services.espanso = let
    espanso-prefix-char = ":";
    espanso-match = trigger: replace: {
      trigger = espanso-prefix-char + trigger;
      replace = replace;
    };
  in {
    enable = true;
    configs.default = {
      backend = "Auto";
      auto_restart = true;
      show_icon = true;
      show_notifications = true;
      preserve_clipboard = true;
      undo_backspace = true;
      toggle_key = "ALT";
      search_shortcut = "ALT+SHIFT+ENTER";
    };
    matches.base.matches = [
      (espanso-match "tuta" tutamail)
      (espanso-match "gmail" gmail)
      (espanso-match "email" email)
      (espanso-match "aumail" aumail)
      (espanso-match "tf" telephone-number)
      (espanso-match "phone" telephone-number)
      (espanso-match "name" name)
      (espanso-match "fname" full-name)
      (espanso-match "addr" "Helsingforsgade 19 st, 4")
      (espanso-match "rg" ''
        Regards
        ${full-name}
      '')
    ];
  };

  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  home.file.".config/hypr/bin/hyprland-arise".source = ./target/release/hyprland-arise;

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
      exec-once = swww init &
      # pkgs.networkmanagerapplet
      exec-once = nm-applet --indicator &
      exec-once = dunst &
      exec-once = waybar &

      exec-once = hypridle
      exec-once = copyq
      exec-once = eww daemon &
      exec-once = udiskie &
      exec-once = wlsunset -t 4000 -T 6500 -S 06:30 -s 18:30
      exec-once = wluma &
      # exec-once = ianny &

      windowrule = animation slide left,kitty
      windowrule = animation popin,dolphin
      windowrule = noblur,^(firefox)$ # disables blur for firefox

      windowrulev2 = tile, class:raylib
      windowrulev2 = bordercolor rgb(1BC156), class:Spotify
      windowrulev2 = bordercolor rgb(4A7AAE), class:telegram
      windowrulev2 = bordercolor rgb(FF00FF) rgb(880808),fullscreen:1 # set bordercolor to red if window is fullscreen
      windowrulev2 = bordercolor rgb(FFFF00),title:^(.*Hyprland.*)$ # set bordercolor to yellow when title contains Hyprland
      windowrulev2 = bordercolor rgb(FF0000),title:^(.*YouTube.*)$ # set bordercolor to red when title contains YouTube
      windowrulev2 = bordercolor rgb(E53E00),title:^(.*Reddit.*)$

      monitor = DP-5, 2560x1440@60, 0x0, 1, bitdepth, 10 # acer monitor at home
      monitor = eDP-1, 2560x1600@60, 0x1440, 1

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
          # "SUPERSHIFT, m, layoutmsg, swapwithmaster"
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
        kb_layout = "us";
        # kb_layout = "us,dk";
        # kb_options = "grp:alt_shift_toggle, caps:swapescape";
        kb_options = "grp:alt_shift_toggle";
        # https://wiki.hyprland.org/Configuring/Variables/#follow-mouse-cursor
        follow_mouse = 2;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.0;
          disable_while_typing = true;
          middle_button_emulation = true;
          drag_lock = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
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

  # home.file.".config/waybar/nix-logo.png".source = ./nix-logo.png;

  programs.waybar = {
    enable = false;
    systemd.enable = true;
    settings = {
      mainbar = {
        layer = "top";
        position = "top";
        spacing = 4; # px
        height = 42;
        margin-top = 5;
        margin-bottom = 5;
        modules-left = [
          # "image#nix-logo"
          "hyprland/workspaces"
          "tray"
        ];
        modules-center = [
          # "hyprland/window"
          "pulseaudio"
          # "pulseaudio/slider"
        ];
        modules-right = [
          "keyboard-state"
          "battery"
          "clock"
          "network"
          # "tray"
          "cpu"
          "memory"
          "temperature"
          "group/group-power"
        ];
        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            children-class = "not-power";
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };

        "custom/quit" = {
          format = "󰗼";
          tooltip = false;
          on-click = "hyprctl dispatch exit";
        };
        "custom/lock" = {
          format = "󰍁";
          tooltip = false;
          on-click = "swaylock";
        };
        "custom/reboot" = {
          format = "󰜉";
          tooltip = false;
          on-click = "systemctl reboot";
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "shutdown now";
        };
        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };
        # "image#nix-logo" = {
        #   path = home.homeDirectory + "/.config/waybar/nix-logo.png";
        #   size = 32;
        #   interval = 60 * 60 * 24;
        #   on-click = "xdg-open 'https://nixos.org/'";
        #   tooltip = true;
        # };
        "hyprland/workspaces" = {
          # format = "{icon}";
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "active" = "";
            "default" = "";
          };
        };
        "hyprland/window" = {
          format = "👉 {}";
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌎 $1";
            "(.*) - fish" = "><> [$1]";
          };
          separate-outputs = true;
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = "{icon} {format_source}";
          format-muted = "{format_source}";
          format-source = "";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = " {name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
        };
        tray = {
          icon-size = 20;
          spacing = 10;
        };
      };
    };
    style = let
      padding = "4px 10px";
    in ''
      * {
        /* font-family: Source Code Pro; */
        font-family: JetBrainsMono Nerd Font;
        /* font-family: monospace; */
        font-size: 16px;
        border: none;
      }

      window#waybar {
        background-color: rgba(40, 42, 54, 0.4);
        border-bottom: 1px solid rgba(40, 42, 55, 0.1);
        border-radius: 0px;
        color: #f8f8f2;
      }

      #workspaces {
        padding: 0 0.5em;
        background-color: @surface0;
        color: @text;
        margin: 0.25em;
      }

      #workspaces button.empty {
        color: @overlay0;
      }

      #workspaces button.visible {
        color: @blue;
      }

      #workspaces button.active {
        color: @green;
      }

      #workspaces button.urgent {
        background-color: @red;
        border-radius: 1em;
        color: @text;
      }

      #image {
        padding: 0.5em 0;
      }


      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #tray,
      #mode {
        padding: 0 10px;
        color: @text;
      }
    '';
  };
}
