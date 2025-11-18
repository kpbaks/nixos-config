# TODO: checkout https://github.com/tieum/atuin-graph
# TODO: checkout https://github.com/YiNNx/cmd-wrapped
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    atuin-desktop
  ];
  programs.atuin = {
    # TODO: 1. add pr to add a `shell` column to the `history` sqlite table, to differentiate between
    #    commands that are valid in `fish` and not in `nushell` and vice versa.
    # TODO: 2. See if catppuccin has a color theme
    # TODO: 3. Add pr that adds syntax coloring for completion candidates
    # TODO: 4. Add pr to search for specific status code e.g. `$?=139` to search for all segfaults
    # TODO: 5. Add pr to enable case insensitive search, or see if it already can be configured
    enable = true;
    # enableFishIntegration = false;
    # enableNushellIntegration = false;
    daemon.enable = true;

    flags = [
      # "--disable-up-arrow"
      # "--disable-ctrl-r"
    ];

    settings = {
      auto_sync = true;
      invert = false;
      inline_height = 20;
      show_preview = true;
      max_preview_height = 4;
      # style = "compact";
      workspaces = true;
      filter_mode_shell_up_key_binding = "session";
      sync_frequency = "1h";
      store_failed = true;
      secrets_filter = true;
      sync_address = "https://api.atuin.sh";
      # search_mode = "prefix";:w

      search_mode = "fuzzy";
      theme.name = "marine";
      stats = {
        common_subcommands = [
          # "apt"
          "cargo"
          # "composer"
          # "dnf"
          "docker"
          "git"
          "go"
          # "ip"
          "kubectl"
          "nix"
          # "nmcli"
          # "npm"
          # "pecl"
          # "pnpm"
          "podman"
          # "port"
          "systemctl"
          "journalctl"
          # "tmux"
          # "yarn"
        ];
        common_prefix = [
          "doas"
          "sudo"
          "run0"
        ];
        ignored_commands = [
          "cd"
          "ls"
          "hx"
          "pwd"
        ];
      };
    };
  };
}
