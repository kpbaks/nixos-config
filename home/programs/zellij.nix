{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.zellij.enable = false;
  home.sessionVariables = {
    ZELLIJ_AUTO_ATTACH = lib.mkForce "false";
    ZELLIJ_AUTO_EXIT = lib.mkForce "false";
  };
  # TODO: how to start zellij with `zellij --layout welcome`
  # TODO: prevent integration if terminal is embedded in another program,
  # ala. in kate or dolphin or vscode
  # `set -q KATE_PID`
  # `set -q VSCODE_INTEGRATION`
  # ZED_TERM=true
  # TODO: find way to detect in intellij ides
  # TODO: show the session resurrection plugin when starting a new fish process not in zellij
  programs.zellij.enableFishIntegration = true;
  programs.zellij.enableBashIntegration = false;
  programs.zellij.enableZshIntegration = false;

  # eval (/nix/store/xpqw2pmjdpsh2kcyxka4m2rpcikf93j7-zellij-0.42.2/bin/zellij setup --generate-auto-start fish | string collect)

  programs.fish.interactiveShellInit =
    lib.optionalString (!config.programs.zellij.enableFishIntegration)
      # fish
      ''
        # WINDOWID is set when in KDE Dolphins embedded terminal
        # KATE_PID=17749
        # ZED_TERM=true
        # TUIOS_WINDOW_ID=c4abe8b9-c57b-41b4-a495-37e1fbcbb943
        if not set -q WINDOWID; and not set -q KATE_PID; and not set -q ZED_TERM; and not set -q TUIOS_WINDOW_ID
        # if set -q XDG_CURRENT_DESKTOP; and test $XDG_CURRENT_DESKTOP != niri
          eval (${config.programs.zellij.package}/bin/zellij setup --generate-auto-start fish | string collect)
        end
      '';

  programs.zellij.settings = {
    # default_mode = "locked";
    default_mode = "normal";
    # TODO: create a wrapper script that handles X11/Wayland and MacOS
    copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
    copy_clipboard = "primary";
    copy_on_selection = true;
    serialize_pane_viewport = true;
    show_startup_tips = false;
    # layout_dir = "${zellij_dir}/layouts";
    # theme_dir = "${zellij_dir}/themes";
    # theme = "gruvbox-dark";
    # theme = "kanagawa";
    # theme = "iceberg-dark";
    # theme = "night-owl";
    # theme = "tokyo-night-light";
    # default_layout = "default";
    # compact-bar location="zellij:compact-bar" { // replace it with these lines
    #     tooltip "F1" // choose a keybinding to toggle the hints
    # }
    # default_layout "compact" // make sure this is set so you'll get the compact-bar instead of the default UI

    plugins = {
      compact-bar = {
        _props.location = "zellij:compact-bar";
        tooltip = "f1";
      };
    };
    default_layout = "compact";
    pane_viewport_serialization = true;

    ui.pane_frames.hide_session_name = false;

    # https://zellij.dev/tutorials/web-client/
    web_server = false;
    # Generated with `nix run nixpkgs#mkcert -install localhost 127.0.0.1`
    web_server_cert = toString /etc/nixos/localhost+1.pem;
    web_server_key = toString /etc/nixos/localhost+1-key.pem;
    enforce_https_over_localhost = true;

    # /home/kpbaks/.nix-profile/bin/hx .
    # /nix/store/wz0j2zi02rvnjiz37nn28h3gfdq61svz-python3-3.12.9/bin/python3.12 /nix/store/wyrz9irhdpcqn9lnalzdyx10blf8xs35-nixpkgs-review-3.1.0/bin/.nixpkgs-review-wrapped rev HEAD
    # TODO: add snippet to zellij docs
    # https://zellij.dev/documentation/options.html?highlight=post_c#post_command_discovery_hook
    post_command_discovery_hook = "echo $RESURRECT_COMMAND | ${pkgs.gnused}/bin/sed -E -e 's/^\/nix\/store\/[^/]+\/bin\///g' -e 's/.*\.nix-profile\/bin\///'";

    keybinds = {
      _props.clear-defaults = false;
      normal._children = [
        # TODO: also bind Alt Shift {Left,Right} to this
        {
          bind = {
            _args = [ "Ctrl PageUp" ];
            GoToNextTab = [ ];
          };
        }
        {
          bind = {
            _args = [ "Ctrl PageDown" ];
            GoToPreviousTab = [ ];
          };
        }
        {
          bind = {
            _args = [ "Ctrl Home" ];
            GoToTab = [ 1 ];
          };
        }
        # FIXME: zellij should have an action like GotoFirstTab, GotoLastTab
        {
          bind = {
            _args = [ "PageUp" ];
            # https://zellij.dev/documentation/keybindings-possible-actions.html#halfpagescrollup
            HalfPageScrollUp = [ ];
          };
        }
        {
          bind = {
            _args = [ "PageDown" ];
            # https://zellij.dev/documentation/keybindings-possible-actions.html#halfpagescrolldown
            HalfPageScrollDown = [ ];
          };
        }
      ]
      ++ map (i: {
        bind = {
          _args = [ "Alt ${toString i}" ];
          GoToTab = [ i ];
        };
      }) (lib.range 1 9);
      # TODO: unbind ctrl+b to go into tmux mode
      # TODO: bind ctrl+/ to go into search mode

      shared_except = {
        _args = [ "locked" ];
        # _props = {
        #   locked = true;
        # };
        _children = [
          {
            bind = {
              _args = [ "Alt t" ];
              # https://zellij.dev/documentation/keybindings-possible-actions.html#launchorfocusplugin
              LaunchOrFocusPlugin = {
                _args = [ "zellij:session-manager" ];
                floating = true;
              };
            };
            unbind = {
              _args = [
                # disable alt+i and alt+o, as I use them in helix
                "Alt i"
                "Alt o"
                "Ctrl o" # Used in helix
                "Ctrl q" # Do not want to accidentally quit
              ];
            };
          }
        ];
      };
    };
  };

  # xdg.configFile."zellij/layouts/default.kdl".text =
  #   # kdl
  #   ''
  #     pane_frames true
  #     simplified_ui false

  #     layout {
  #       default_tab_template {
  #         pane size=1 borderless=true {
  #           plugin location="zellij:tab-bar"
  #         }

  #         children

  #         pane size=1 borderless=true {
  #           plugin location="zellij:status-bar"
  #         }
  #       }
  #     }
  #   '';

  # TODO: dependent on my pr `feature/query-pane-names`
  # programs.fish.interactiveShellInit =
  #   let
  #     zellij = "${self.programs.zellij.package}/bin/zellij";
  #     toggle-pane-frames = # fish
  #       ''
  #         set -l panes (${zellij} action query-pane-names)
  #         if test (count $panes) -gt 1
  #           ${zellij} action toggle-pane-frames
  #         end
  #       '';
  #   in
  #   # fish
  #   ''
  #     if set -q ZELLIJ
  #       ${toggle-pane-frames}

  #       function _zellij_toggle_pane_frames_on_exit --on-event fish_exit
  #         ${toggle-pane-frames}
  #       end
  #     end
  #   '';

  # TODO: condition on `lib.versionAtLeast cfg.package.version "0.43.0"` and the package being compiled
  # with web server support, and cfg.enable
  systemd.user.services.zellij-web-server = {
    Unit = {
      Description = "Start the zellij web server";
      Documentation = builtins.concatStringsSep " " [
        "https://zellij.dev/documentation/web-client.html?highlight=web#web-client"
        "https://zellij.dev/tutorials/web-client/"
      ];
      After = [
        "nss-lookup.target" # Need to be able to resolve 'localhost'
        "graphical-session.target" # Need a browser for the feature a to be useful
      ];
    };

    Service =
      let
        zellij = lib.getExe config.programs.zellij.package;
      in
      {
        Type = "exec";
        ExecStart = "${zellij} web --start";
        ExecStop = "${zellij} web --stop";
      };

    Install.WantedBy = [ "multi-user.target" ];
  };
}
