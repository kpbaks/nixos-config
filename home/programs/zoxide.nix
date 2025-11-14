{
  config,
  lib,
  ...
}:
let
  enable = true;
  cmd = "cd";
in
{
  programs.zoxide = {
    inherit enable;
  };
  programs.zoxide.enableNushellIntegration = true;
  # programs.zoxide.enablePowershellIntegration = true;
  programs.zoxide.options = [
    "--cmd=${cmd}" # override `cd` and create `cdi`
    "--hook=pwd"
  ];

  programs.fish.functions.z =
    # fish
    ''
      if (count $argv) -eq 0
        cdi
      else
        cd $argv
      end
    '';

  # TODO: there should be an option to ignore subdirs in a git repo. I do not think you can capture
  # that in a glob
  home.sessionVariables = rec {
    _ZO_FZF_OPTS =
      let
        kvpairs =
          attrs:
          with builtins;
          concatStringsSep "," (map (name: "${name}:${getAttr name attrs}") (attrNames attrs));
        bind = kvpairs {
          tab = "jump";
          jump = "accept";
        }; # Magic 😩
        color = kvpairs rec {
          # border = "#01346b";
          hl = "#e43a25";
          selected-hl = "${hl}:bold";
          # TODO: set color for the jump label
          fg = "dim";
          selected-fg = "-1"; # Default terminal color
        };
      in
      # FIXME: make colors work with a light theme
      lib.concatStringsSep " " [
        # "--height=~80%"
        "--height=~100%"
        "--border=rounded"
        "--border-label=' zoxide (tab to jump) '"
        "--cycle"
        # TODO: create pr that adds a color to the score and highlight the basename
        # different from the dirname
        "--ansi"
        "--reverse"
        "--highlight-line"
        "--no-scrollbar"
        "--pointer='=>'"
        "--cycle"
        "--bind=${bind}"
        "--color=${color}"
      ];
    _ZO_RESOLVE_SYMLINKS = 0; # false
    _ZO_MAXAGE = 10000; # default
    _ZO_EXCLUDE_DIRS = lib.makeBinPath [
      config.home.homeDirectory
      "*.git/*"
    ]; # Default aka. "$HOME"

    # https://yazi-rs.github.io/docs/plugins/builtins#zoxide
    # https://github.com/sxyazi/yazi/blob/cd6881c9fe88dfe73d91980829fd371f5eeec242/yazi-plugin/preset/plugins/zoxide.lua#L48
    # TODO: document this env var in yazi docs
    YAZI_ZOXIDE_OPTS = _ZO_FZF_OPTS;
  };

  programs.fish.shellInitLast =
    lib.mkIf enable
      # fish
      ''
        # TODO: if running in zellij only run if in a single pane tab
        # AFAICT zellij does not expose a way through the `zellij` binary of querying
        # number of panes in a tab.
        # if set -q ZELLIJ
        #   ${cmd}i
        # else
        #   ${cmd}i
        # end
      '';
}
