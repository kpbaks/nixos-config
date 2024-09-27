{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    # $\{env_var.AGAIN_ENABLED}
    # $\{env_var.AGAIN_DYNAMIC_ENABLED}
    settings = {
      format = lib.concatStrings (
        map (mod: "\$${mod}") [
          "localip"
          "nix_shell"
          "shell"
          "jobs"
          "shlvl"
          "character"
        ]
      );
      right_format = lib.concatStrings (
        map (mod: "\$${mod}") [
          "direnv"
          "directory"
          "git_branch"
          "git_commit"
          "git_state"
          "git_metrics"
          "git_status"
          "typst"
          "rust"
          "julia"
          "package"
        ]
      );
      add_newline = false;
      git_metrics.disabled = true;
      directory.fish_style_pwd_dir_length = 2;
      shell = {
        disabled = false;
        fish_indicator = "fish";
        nu_indicator = "nu";
        bash_indicator = "bash";
      };
      localip = {
        disabled = false;
        format = "@[$localipv4]($style) ";
        style = "dimmed yellow";
        ssh_only = false;
      };
      package = {
        disabled = false;
        symbol = "📦";
        format = "[$symbol$version]($style) ";
      };
      time = {
        disabled = false;
        style = "cyan";
        format = "[$time]($style)";
      };
      jobs = {
        symbol = "jobs ";
        number_threshold = 1;
        symbol_threshold = 1;
      };
      shlvl = {
        disabled = true;
        format = "$shlvl level(s) down";
        threshold = 3;
      };
      direnv = {
        disabled = false;
        format = "[$symbol$loaded/$allowed]($style) ";
        style = "dimmed orange";
      };
      nix_shell = {
        format = "[$symbol $state( \($name\))]($style) ";
        symbol = "❄️";
        style = "bold fg:#7E7EFF";
      };
      # NOTE: only works with `nix-shell -p <package>`, not `nix shell nixpkgs#<package>`
      # env_var.IN_NIX_SHELL = {
      #   variable = "IN_NIX_SHELL";
      #   default = "";
      #   style = "bold fg:magenta";
      #   format = "[<nix-shell>]($style) ";
      #   description = "Show that you are in a `nix-shell -p ...`";
      # };
      # env_var = {
      #   AGAIN_ENABLED = {
      #     symbol = "◉";
      #     style = "bold fg:red";
      #     default = "";
      #     format = "[$env_value]($style)";
      #     description = "again.fish";
      #     disabled = false;
      #   };
      #   AGAIN_DYNAMIC_ENABLED = {
      #     symbol = "◉";
      #     style = "bold fg:red";
      #     default = "";
      #     format = "[$env_value]($style)";
      #     description = "again.fish";
      #     disabled = false;
      #   };
      #   DIRENV_FILE = {
      #     symbol = " ";
      #     style = "bold fg:cyan";
      #     default = "";
      #     format = "[direnv]($style)";
      #     description = "direnv";
      #     disabled = false;
      #   };
      # };
    };
  };
}
