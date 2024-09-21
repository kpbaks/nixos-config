{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    # catppuccin.enable = false;
    extraPackages = with pkgs.bat-extras; [
      # batdiff
      batman
      batgrep
      batwatch
    ];
    syntaxes = {
      gleam = {
        src = pkgs.fetchFromGitHub {
          owner = "molnarmark";
          repo = "sublime-gleam";
          rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
          hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
        };
        file = "syntax/gleam.sublime-syntax";
      };
    };

    config = {
      # TODO: check if bat supports pr for this
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
        "*.jupyterlab-settings:json5"
        "*.zon:zig"
        "flake.lock:json"
        "*.cu:cpp"
        "conanfile.txt:ini"
        "justfile:make"
        "Justfile:make"
        "*.msproj:xml"
      ];
    };
  };
}
