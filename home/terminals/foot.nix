{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
    settings = {
      main = {
        # term = "xterm-256color";
        # font = "JetBrains Nerd Font Mono:size=14";
        font = "JetBrainsMono Nerd Font:size=10";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 0.9;
      };

      desktop-notifications = {
        inhibit-when-focused = "yes";
      };

      key-bindings = {
        # pipe-command-output = "[${pkgs.wl-clipboard}/bin/wl-copy] Control+Shift+c"; # Copy last command's output to the clipboard
      };

      # [desktop-notifications]
      # # command=notify-send --wait --app-name ${app-id} --icon ${app-id} --category ${category} --urgency ${urgency} --expire-time ${expire-time} --hint STRING:image-path:${icon} --hint BOOLEAN:suppress-sound:${muted} --hint STRING:sound-name:${sound-name} --replace-id ${replace-id} ${action-argument} --print-id -- ${title} ${body}
      # # command-action-argument=--action ${action-name}=${action-label}
      # # close=""
      # # inhibit-when-focused=yes

      cursor = {
        blink = true;
        style = "beam";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  # FIXME: seems to not work
  programs.fish.functions = {
    # https://codeberg.org/dnkl/foot/wiki#fish-1
    _foot_mark_prompt_start = {
      onEvent = "fish_prompt";
      body = ''echo -en "\e]133;A\e\\"'';
    };
    # https://codeberg.org/dnkl/foot/wiki#fish-2
    _foot_mark_cmd_start = {
      onEvent = "fish_preexec";
      body = ''echo -en "\e]133;C\e\\"'';
    };

    _foot_mark_cmd_end = {
      onEvent = "fish_postexec";
      body = ''echo -en "\e]133;D\e\\"'';
    };
  };
}
