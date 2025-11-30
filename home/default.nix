{ inputs, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  imports = [
    ./shell-aliases.nix
    ./quickshell
    ./noctalia
    # ./bars
    ./browsers
    # ./calendar.nix
    ./custom-modules
    # ./desktop-environments
    ./direnv.nix
    ./email.nix
    ./environment-variables.nix
    ./fonts.nix
    # ./git.nix
    # TODO move under ./desktop-environments
    # ./kde-plasma
    ./launchers
    ./modules
    # ./nixvim.nix
    # ./notification-daemons
    ./packages.nix
    ./pgp.nix
    ./programming-languages
    ./programs
    ./scripts
    ./services
    ./shells
    ./spotify.nix
    ./terminals
    ./text-editors
    ./vcs
    ./wms
    ./xdg
    ./obsidian.nix
    ./tldr.nix
    ./k8s-dev.nix
    inputs.git-new.homeModules.default
  ];

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

  # nix.gc = {
  #   automatic = true;
  #   frequency = "weekly";
  #   options = null;
  # };

  systemd.user.startServices = "sd-switch";

  # automatically set some environment variables that will ease usage of software installed with nix on non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc.)
  # targets.genericLinux.enable = false;

  # programs.btop.enable = false;

  programs.jq.enable = true;

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  # TODO: use systemd env var activation condition to activate on niri
  # services.network-manager-applet.enable = false;

  # gtk.enable = true;

  # gtk.theme = {
  #   # name = "adw-gtk3";
  #   name = "Adwaita";
  #   package = pkgs.adw-gtk3;
  # };

  # gtk.gtk2.extraConfig = ''gtk-application-prefer-dark-theme = 1'';

  # gtk.gtk3.extraConfig = {
  #   gtk-application-prefer-dark-theme = 1;
  # };

  # gtk.gtk4.extraConfig = {
  #   gtk-application-prefer-dark-theme = 1;
  # };

  # gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  # qt.enable = true;
  # qt.style.name = "kvantum";
  # qt.platformTheme.name = "kvantum";
  # qt.style.catppuccin.enable = false;
  # catppuccin.kvantum.enable = false;
  # qt.style.name = "breeze";
  # qt.platformTheme.name = "kde";

  # qt = {
  #   style.package = [
  #     inputs.darkly.packages.${pkgs.stdenv.hostPlatform.system}.darkly-qt5
  #     inputs.darkly.packages.${pkgs.stdenv.hostPlatform.system}.darkly-qt6
  #   ];
  #   platformTheme.name = "qtct";
  # };

  # home.pointerCursor = {
  #   name = "phinger-cursors-light";
  #   package = pkgs.phinger-cursors;
  #   size = 32;
  #   gtk.enable = true;
  # };

  # services.poweralertd.enable = osConfig.services.upower.enable;
  # services.poweralertd.enable = true;

  programs.openscad.enable = false; # custom-modules/openscad.nix

  # custom-modules/gitu.nix

  # programs.nix-your-shell.enable = true;

  programs.nix-init = {
    enable = true;
    settings = {
      maintainers = [ "kpbaks" ];
      nixpkgs = ''builtins.getFlake "nixpkgs"'';

      access-tokens = {
        # "gitlab.com".command = [];
      };
    };
  };

  programs.cavalier.enable = false;

  home.shell = {
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.satty = {
    enable = true;
    settings = {
      general = {
        fullscreen = true;
        corner-roundness = 12;
        initial-tool = "brush";
        output-filename = "/tmp/test-%Y-%m-%d_%H:%M:%S.png";
      };
      color-palette = {
        palette = [
          "#00ffff"
          "#a52a2a"
          "#dc143c"
          "#ff1493"
          "#ffd700"
          "#008000"
        ];
      };
    };
  };

  programs.vivid = {
    enable = true;
    activeTheme = "tokyonight-moon";
  };

  # services.shpool = {
  #   enable = true;
  # };

  programs.numbat = {
    enable = true;
  };

  programs.waveterm = {
    enable = true;
  };

  programs.tray-tui.enable = true;
  programs.twitch-tui.enable = true;
  # services.ssh-tpm-agent.enable = true;
  programs.radio-cli.enable = true;
  programs.nix-search-tv.enable = true;

  programs.grep = {
    enable = true;
    # # TODO: improve colors, to not use default red
    # # https://www.gnu.org/software/grep/manual/html_node/Environment-Variables.html
    # GREP_COLORS = "ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36";

    colors = {
      error = "01;31";
    };
  };

  # programs.lutris.enable = true;

  # TODO: try out
  # programs.meli = {
  #   enable = true;
  # };

  # programs.docker-cli = {
  #   enable = true;
  # };

  xdg.configFile."tombi/config.toml".source = (pkgs.formats.toml { }).generate "tombi-config" {
    lint.rules.tables-out-of-order = "off";
  };

  programs.zotero.enable = true;
  programs.neohtop.enable = false;
  programs.calibre.enable = true;

  # TODO: add an option to set a high level config like "niri"
  # to generate commands for lock and turn of monitors that makes
  # use of the functionality of the wm.
  # https://github.com/AMNatty/wleave
  # TODO: configure colors to match niri accent colors
  programs.wleave.enable = true;

  # https://github.com/XAMPPRocky/tokei/blob/master/tokei.example.toml
  # TODO: create hm module
  xdg.configFile."tokei/tokei.toml".source = tomlFormat.generate "tokei-config" {
    sort = "lines";
    num-format = "underscores";
  };

  programs.asciinema.enable = true;
  # programs.amp.enable = true;
  # programs.andcli.enable = true;
  # programs.anup.enable = true;
  # services.autotiling.enable = false;
  # programs.anvil-editor.enable = true;

  # services.wl-clip-persist.enable = true;
}
