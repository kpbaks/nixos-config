{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
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
      # FIXME: figure out how to apply a text substitution on the downloaded file
      # nushell = {
      #   src = pkgs.fetchFromGitHub {
      #     owner = "kurokirasama";
      #     repo = "nushell_sublime_syntax";
      #     rev = "ad8cd6702b3097b34abd8e8e8ec8137e5a2324c0";
      #     hash = "sha256-kDdsX/srl9N0NqXG7uEh22YQvYYCGHDHARkncE6tvJA=";
      #   };
      #   file = "nushell.sublime-syntax";
      # };
    };

    config = {
      # TODO: check if bat supports pr for this
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
        "*.jupyterlab-settings:json5"
        "*.zon:zig"
        "flake.lock:json5"
        "*.cu:cpp"
        "conanfile.txt:ini"
        "justfile:make"
        "Justfile:make"
        "*.msproj:xml"
        "*.nu:nushell"
      ];
    };
  };
}
