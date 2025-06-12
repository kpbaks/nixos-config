{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # dependabot-cli
  ];

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-eco
      gh-markdown-preview
      # gh-notify
      # gh-cal
      # gh-f
      # gh-poi
      gh-actions-cache
      # gh-copilot
      # gh-screensaver
    ];

    # settings.git_protocol = "https"; # or "ssh"
    settings.git_protocol = "ssh"; # or "ssh"
    settings.aliases = {
      co = "pr checkout";
      conflicts = "diff --name-only --diff-filter=U --relative";
    };
  };

  programs.gh-dash.enable = true;

}
