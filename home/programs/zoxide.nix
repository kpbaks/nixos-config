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
  home.sessionVariables = {
    _ZO_FZF_OPTS = lib.concatStringsSep " " [
      "--height=~80%"
      "--border=rounded"
      "--border-label=' zoxide '"
      "--cycle"
      # TODO: create pr that adds a color to the score and highlight the basename
      # different from the dirname
      "--ansi"
    ];
    _ZO_RESOLVE_SYMLINKS = 0; # false
    _ZO_MAXAGE = 10000; # default
    _ZO_EXCLUDE_DIRS = lib.makeBinPath [
      config.home.homeDirectory
      "*.git/*"
    ]; # Default aka. "$HOME"
  };

  programs.fish.shellInitLast = lib.mkIf enable ''${cmd}i'';
}
