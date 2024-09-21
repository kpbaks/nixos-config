{ ... }:
{
  programs.starship = {
    enable = true;
    # catppuccin.enable = false;
    enableTransience = true;
    # $\{env_var.AGAIN_ENABLED}
    # $\{env_var.AGAIN_DYNAMIC_ENABLED}
    settings = {
      format = ''$shell$jobs$shlvl$character'';
      # right_format = ''$direnv$directory$git_branch$git_commit$git_state$git_metrics$git_status$package$time'';
      right_format = ''$direnv$directory$git_branch$git_commit$git_state$git_metrics$git_status$package'';
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
        format = "@[$localipv4](bold yellow) ";
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
        style = "bold orange";
      };
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
