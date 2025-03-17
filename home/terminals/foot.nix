{
  programs.foot = {
    enable = true;
    server.enable = true;
    # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
    settings = {
      main = {
        # term = "xterm-256color";
        # font = "JetBrains Nerd Font Mono:size=14";
        font = "JetBrainsMono Nerd Font Mono:size=12";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 1.0;
      };

      security.osc52 = "enabled";

      desktop-notifications = {
        inhibit-when-focused = "yes";
      };

      # [key-bindings]
      # # scrollback-up-page=Shift+Page_Up Shift+KP_Page_Up
      # # scrollback-up-half-page=none
      # # scrollback-up-line=none
      # # scrollback-down-page=Shift+Page_Down Shift+KP_Page_Down
      # # scrollback-down-half-page=none
      # # scrollback-down-line=none
      # # scrollback-home=none
      # # scrollback-end=none
      # # clipboard-copy=Control+Shift+c XF86Copy
      # # clipboard-paste=Control+Shift+v XF86Paste
      # # primary-paste=Shift+Insert
      # # search-start=Control+Shift+r
      # # font-increase=Control+plus Control+equal Control+KP_Add
      # # font-decrease=Control+minus Control+KP_Subtract
      # # font-reset=Control+0 Control+KP_0
      # # spawn-terminal=Control+Shift+n
      # # minimize=none
      # # maximize=none
      # # fullscreen=none
      # # pipe-visible=[sh -c "xurls | fuzzel | xargs -r firefox"] none
      # # pipe-scrollback=[sh -c "xurls | fuzzel | xargs -r firefox"] none
      # # pipe-selected=[xargs -r firefox] none
      # # pipe-command-output=[wl-copy] none # Copy last command's output to the clipboard
      # # show-urls-launch=Control+Shift+o
      # # show-urls-copy=none
      # # show-urls-persistent=none
      # # prompt-prev=Control+Shift+z
      # # prompt-next=Control+Shift+x
      # # unicode-input=Control+Shift+u
      # # noop=none
      # # quit=none

      key-bindings = {
        # pipe-command-output = "[${pkgs.wl-clipboard}/bin/wl-copy] Control+Shift+c"; # Copy last command's output to the clipboard
        fullscreen = "f11";
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
