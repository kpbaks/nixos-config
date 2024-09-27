# TODO: package these for nixpkgs:
# - https://github.com/darrenburns/posting
# - https://github.com/achristmascarl/rainfrog
{ pkgs, ... }:
let
  kde-packages = with pkgs.kdePackages; [
    neochat
    # plasma-workspace # for krunner
    # kolourpaint
  ];
in
{
  # TODO: checkout
  # https://github.com/arunsupe/semantic-grep
  # TODO: document all pkgs
  # TODO: checkout https://github.com/azzamsa/zman
  # TODO: checkout https://github.com/6543/batmon/
  home.packages =
    with pkgs;
    [
      cfonts
      zbar # `zbarimg` and `zbarcam`, utilities to work with qr codes
      nodePackages_latest.fkill-cli
      tparse
      rich-cli
      plocate # Much faster `locate`
      curlie # prettier alternative to `curl`
      vlc # media player
      hurl # http request test tool
      # bruno # non shitty alternative to postman and insomnia
      droidcam
      xwayland-satellite
      speedtest-cli
      cfspeedtest
      hut # sourcehut cli
      tea # gitea cli
      codeberg-cli
      eww
      ripgrep-all # `rga`
      cmd-wrapped
      # superfile # `spf`
      completely
      complgen
      # TODO: package this for nixpkgs
      # csvtk # https://github.com/shenwei356/csvtk
      datamash
      youplot
      xsv
      # kdeplasma-addons
      # davinci-resolve
      kdenlive
      video-trimmer
      identity
      # image-analyzer
      # kaf

      # gotty
      # gomp # https://github.com/MarkForged/GOMP
      openjdk
      # qt version recommended if you use kde-plasma
      # https://wiki.nixos.org/wiki/LibreOffice
      libreoffice-qt
      hunspell # https://github.com/hunspell/hunspell
      hunspellDicts.da-dk
      hunspellDicts.en-us
      onlyoffice-bin
      desktop-file-utils # https://www.freedesktop.org/wiki/Software/desktop-file-utils/
      vhs
      # ruby_3_3
      swappy
      grim
      tesseract
      legit
      birdtray
      pstree
      dprint
      brotab
      nb
      wl-clipboard
      # wl-clipboard-rs
      erdtree
      process-compose # Like `docker-compose` for ordinary processes
      wtype # xdotool for wayland
      # jetbrains-toolbox
      # jetbrains.rider
      # jetbrains.rust-rover
      # jetbrains.clion
      # jetbrains.pycharm-community-bin
      teams-for-linux
      # teams
      # yad
      # zenity
      # trippy # provides `trip` binary
      # viddy # A modern watch command. Time machine and pager etc.
      # tabview
      rustscan # portscanner like `nmap`
      # ollama
      # ollama-cuda
      # ollama-rocm
      # calibre
      # calibre-web
      # soco-cli # cli tools to interact with sonos devices
      # delta # FIXME: does not compile tor 15 aug 15:31:05 CEST 2024
      # helvum # GTK-based patchbay for pipewire
      watchexec
      # rerun # FIXME: does not compile
      # logseq
      # smassh # TUI based typing test application inspired by MonkeyType
      kondo # cleans dependencies and build artifacts from your projects.
      # TODO: integrate with helix
      # tickrs #  Realtime ticker data in your terminal 📈
      # ticker #  Terminal stock ticker with live updates and position tracking
      # mop #  Stock market tracker for hackers.
      # newsflash # rss reader
      wl-color-picker
      # element
      # element-desktop
      gping
      # fuzzel
      resvg
      miller
      csview
      # pympress
      mission-center
      # mkchromecast
      samply
      sad
      sd
      # ungoogled-chromium
      # vivaldi
      asciigraph
      imagemagick
      # c3c
      lychee
      # tutanota-desktop
      localsend # open source alternative to Apple Airdrop
      # inkscape
      # gimp
      # dogdns # rust alternative to dig
      # TODO: use home-manager module when ready
      zed-editor
      # TODO: integrate with `cmake.fish`
      upx
      ripdrag # drag and drop files from the terminal
      caddy # Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS
      # charm-freeze
      pastel
      vivid
      # wdisplays
      # nwg-dock
      # nwg-drawer
      # nwg-displays
      # FIXME: no wayland support
      # daktilo # turn your keyboard into a typewriter!
      # lemmyknow # identify anything
      the-way # termial snippet-manager
      appflowy # open source alternative to notion
      # macchina # neofetch like program
      # neovim-remote # TODO: create `darkman` script to toggle light/dark mode with `set background=dark`
      lurk # like `strace` but with colors
      kdiff3
      meld
      # spotify-player
      # micro
      procs
      # jitsi
      # jitsi-meet
      # clipse # tui clipbard manager
      # gnomeExtensions.pano # fancy clipboard manager
      devenv
      ffmpeg
      ffmpegthumbnailer
      libwebp # why do 'r/wallpaper' upload all its images in `webp`
      # tabnine
      # grit
      # d2
      graphviz
      aria
      # wofi
      # rofi-emoji-wayland # `rofimoji`
      # rofi-wayland
      pavucontrol # audio sink gui
      overskride # bluetooth gui
      wf-recorder # wayland screen recorder
      wl-screenrec # wayland screen recorder
      # ianny
      wluma
      wlsunset # set screen gamma (aka. night light) based on time of day
      pdf2svg
      poppler_utils # pdf utilities
      # webcord # fork of discord, with newer electron version, to support screen sharing
      vesktop # Vesktop is a custom Discord App aiming to give you better performance and improve linux support
      hyprshot # screenshot tool designed to integrate with hyprland
      grim # wayland screenshot tool
      slurp # wayland tool to make a screen selection
      # udiskie # daemon used to automatically mount external drives like USBs
      # flameshot
      brightnessctl # control screen brightness
      thunderbird # email client
      # discord
      telegram-desktop # messaging client
      # spotify # music player
      # zotero # citation/bibliography manager
      # copyq # clipboard manager
      libnotify # for `notify-send`
      # TODO: use one of these
      swaylock
      hyprpicker # wlroots-compatible wayland color picker
      pamixer # control audio levels
      playerctl # media player controller
      timg # terminal image viewer
      # swaynotificationcenter # wayland notification daemon
      # mako # wayland notification daemon
      # cliphist # clipboard history
      # wezterm # terminal
      # alejandra # nix formatter
      # eww # custom desktop widgets
      htop # system resource monitor
      just # command runner
      cmake # C/C++ build system generator
      ninja # small build system with a focus on speed
      # kate # text editor
      duf # disk usage viewer
      du-dust # calculate directory sizes. `du` replacement
      # eza # `ls` replacement
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
      # bun # javascript runtime and dev tool
      zoxide # intelligent `cd`
      fastfetch # a faster neofetch
      # TODO: use in `git.fish`
      onefetch # git repo fetch
      zip
      unzip
      file
      anki # flashcard app
      mpv # media player
      bitwarden # password manager
      bitwarden-cli # bitwarden cli
      pass # password manager
      pre-commit # git hook manager
      glow # terminal markdown viewer
      mdcat # terminal markdown viewer
      hyperfine # powerful cli benchmark tool
      # nickel # configuration language
      # nls # nickel language server
      gcc
      gdb
      mold # modern linker
      rustup # rust toolchain manager
      # rclone # rsync for cloud storage
      # croc # easily and securely transfer files and folders from one computer to another
      # sshx
      gnuplot # plotting utility
      vulkan-tools # vulkan utilities

      # brotab

      ouch # {,de}compression tool
      # inlyne # markdown viewer
      # neovide # neovim gui
      taplo # toml formatter/linter/lsp
      web-ext # helper program to build browser extensions and debug instrument firefox
      # firefox-devedition

    ]
    ++ kde-packages;
}
