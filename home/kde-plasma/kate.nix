{ pkgs, ... }:
{
  programs.kate.enable = true;
  programs.kate.editor.brackets = {
    automaticallyAddClosing = true;
    flashMatching = true;
    highlightMatching = true;
    highlightRangeBetween = true;
  };
  programs.kate.editor.font = {
    family = "JetBrains Mono";
    pointSize = 14;
  };

  # https://docs.kde.org/stable5/en/kate/kate/kate-application-plugin-lspclient.html
  programs.kate.lsp.customServers = {
    nixd = {
      command = [
        "${pkgs.nixd}/bin/nixd"
        "--inlay-hints"
        "--semantic-tokens"
      ];

      url = "https://github.com/nix-community/nixd";
      highlightingModeRegex = "^Nix$";
    };

    nu-lsp = {
      command = [
        "${pkgs.nushell}/bin/nu"
        "--lsp"
      ];
      # TODO: kate does not regognize .nu files
      highlightingModeRegex = "^Nu$";
    };
  };
}
