# TODO: integrate https://github.com/imsi32/yatline.yazi
# https://github.com/ndtoan96/ouch.yazi
# https://github.com/Mellbourn/ls-colors.yazi
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs) fetchFromGitHub;
in
{
  imports = [
    ./confirm-quit.nix
    ./folder-rules.nix
    ./goto-project-root-dir.nix
    ./pkg-config.nix
    # ./file-navigation-wraparound.nix
    # ./linemode.nix
  ];

  # TODO: add pr to add a `programs.yazi.extraPackages` option
  home.packages = with pkgs; [
    p7zip # opt dependency of `yazi`
    ueberzugpp # opt dependency of `yazi`
    exiftool # needed for `yazi` functionality
    ouch # needed by "ouch.yazi
  ];

  programs.yazi =
    let
      # yazi-plugins = fetchFromGitHub {
      #   owner = "yazi-rs";
      #   repo = "plugins";
      #   rev = "273019910c1111a388dd20e057606016f4bd0d17";
      #   hash = "sha256-80mR86UWgD11XuzpVNn56fmGRkvj0af2cFaZkU8M31I=";
      # };

      # ouch-yazi = fetchFromGitHub {
      #   owner = "ndtoan96";
      #   repo = "ouch.yazi";
      #   rev = "ce6fb75431b9d0d88efc6ae92e8a8ebb9bc1864a";
      #   hash = "sha256-oUEUGgeVbljQICB43v9DeEM3XWMAKt3Ll11IcLCS/PA=";
      # };
      # kdeconnect-yazi = pkgs.fetchFromGitHub {
      #   owner = "kpbaks";
      #   repo = "kdeconnect.yazi";
      #   rev = "f6ae6bd007be970ac17fafc0a84d87eeeb1c4494";
      #   hash = "sha256-sr92pLVzY/f+MnhhAEbdefz99QdlZRN3x+yQFtXUMD8=";
      # };

    in
    {
      enable = true;
      # https://yazi-rs.github.io/docs/quick-start#shell-wrapper
      shellWrapperName = "y";
      settings = {
        mgr = {
          ratio = [
            2
            4
            3
          ];
          scrolloff = 5;
          show_hidden = true;
          show_symlink = true;
          sort_by = "natural";
          sort_dirs_first = true;
        };

        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
          prepend_previewers =
            map
              (mime: {
                inherit mime;
                run = "ouch";
              })
              [
                "application/*zip"
                "application/x-tar"
                "application/x-bzip2"
                "application/x-7z-compressed"
                "application/x-rar"
                "application/x-xz"
              ];
        };
      };

      # TODO: change home-manager docs to specify that it should be dir with a `main.lua`
      # file and not a `init.lua`
      # see: https://home-manager-options.extranix.com/?query=yazi&release=master
      plugins = {
        chmod = "${inputs.yazi-plugins}/chmod.yazi";
        full-border = "${inputs.yazi-plugins}/full-border.yazi";
        max-preview = "${inputs.yazi-plugins}/max-preview.yazi";
        git = "${inputs.yazi-plugins}/git.yazi";
        vcs-files = "${inputs.yazi-plugins}/vcs-files.yazi";
        no-status = "${inputs.yazi-plugins}/no-status.yazi";
        # TODO: setup this plug
        mime-ext = "${inputs.yazi-plugins}/mime-ext.yazi";
        smart-filter = "${inputs.yazi-plugins}/smart-filter.yazi";
        jump-to-char = "${inputs.yazi-plugins}/jump-to-char.yazi";
        ouch = "${inputs.ouch-yazi}";
        # starship = "${starship-yazi}";
        # kdeconnect = "${kdeconnect-yazi}";
      };

      initLua =
        # lua
        ''
          require("full-border"):setup {
              -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
              type = ui.Border.ROUNDED,
          }
          require("git"):setup()
          require("no-status"):setup()

          -- https://yazi-rs.github.io/docs/plugins/builtins/#zoxide
          require("zoxide"):setup {
            update_db = true,
          }
        '';

      keymap =
        let
          cd = key: dir: {
            run = "cd ${dir}";
            on = [ "g" ] ++ (builtins.filter (x: x != "" && x != [ ]) (builtins.split "" key)); # why split function so weird ...
            desc = "Go to ${dir}";
          };
        in
        {
          mgr.prepend_keymap =
            let
              keymap =
                {
                  keys,
                  run,
                  desc ? "",
                }:
                let
                  on = [ ];
                in
                {
                  inherit run desc on;
                };
            in
            [
              {
                # FIXME: `--all does not work here`
                run = ''shell "ripdrag --all --and-exit $@" --confirm'';
                on = [ "<c-d>" ];
                desc = "Open selected files with `ripdrag`";
              }
              {
                # Like in helix
                run = "arrow bot";
                on = [
                  "g"
                  "e"
                ];
                desc = "Move cursor to end";
              }
              {
                run = "help";
                on = [ "?" ];
                desc = "Open help overview";
              }
              {
                run = "close";
                on = [ "q" ];
                desc = "Close yazi";
              }
              # {
              #   run = "cd "
              # }
              (cd "m" "~/Music")
              (cd "p" "~/Pictures")
              (cd "b" "~/Documents") # b for books, which I mostly keep in my ~/Documents folder
              (cd "v" "~/Videos")
              # (cd "n" "/etc/nixos")
              (cd "," "/etc/nixos") # ',' is commonly used in gui apps for "open configuration" action
              # (cd "r" "/") # r for root
              (cd "/" "/")
              # (cd "s" "~/Pictures/screenshots")
              (cd "s" (baseNameOf config.programs.niri.settings.screenshot-path))
              (cd "o" "~/development/own")
              # (cd "Df" "~/development/forks")
              # (cd "Dc" "~/development/cloned")
              (cd "c" "~/clones")
              (cd "f" "~/forks")
              (cd "." config.xdg.configHome)
              # (cd "x")
              (cd "y" "~/.config/yazi")

              {
                on = [ "F" ];
                run = "plugin smart-filter";
                desc = "Smart filter";
              }
              {
                on = [ "f" ];
                run = "plugin jump-to-char";
                desc = "Jump to char";
              }
              {
                on = [ "T" ];
                run = "plugin --sync max-preview";
                desc = "Maximize or restore preview";
              }
              {
                on = [ "K" ];
                run = "plugin --sync kdeconnect";
                desc = "";
              }
              # {
              #   on = [
              #     "g"
              #     "c"
              #   ];
              #   run = "plugin vcs-files";
              #   desc = "Show Git changed files";
              # }
            ];
        };
    };

  # https://yazi-rs.github.io/docs/quick-start#shell-wrapper
  # programs.fish.functions.y =
  #   # fish
  #   ''
  #       set -l latest_mtime 0
  #       set -l latest_file
  #       for f in *
  #           set -l mtime (path mtime $f)
  #           if test $mtime -gt $latest_mtime
  #               set latest_mtime $mtime
  #               set latest_file $f
  #           end
  #       end

  #     	set tmp (mktemp -t "yazi-cwd.XXXXXX")
  #     	${pkgs.yazi}/bin/yazi $argv --cwd-file="$tmp" $latest_file
  #     	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
  #     		builtin cd -- "$cwd"
  #     	end
  #     	command rm -f -- "$tmp"
  #   '';

  # programs.nushell.extraConfig =
  #   # nu
  #   ''
  #     def --env y [...args] {
  #     	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  #     	${pkgs.yazi}/bin/yazi ...$args --cwd-file $tmp
  #     	let cwd = (open $tmp)
  #     	if $cwd != "" and $cwd != $env.PWD {
  #     		cd $cwd
  #     	}
  #     	rm -fp $tmp
  #     }
  #   '';

  # TODO: check if this is already added when enabling `programs.yazi.enableFishIntegration`
  # programs.fish.interactiveShellInit = # fish
  #   ''
  #     # Change Yazi's CWD to PWD on subshell exit
  #     if test -n $YAZI_ID
  #     	trap 'ya pub dds-cd --str "$PWD"' EXIT
  #     end
  #   '';

  # programs.bash.shellInit = ;
  # function y() {
  # 	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  # 	yazi "$@" --cwd-file="$tmp"
  # 	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
  # 		builtin cd -- "$cwd"
  # 	fi
  # 	rm -f -- "$tmp"
  # }
}

# scripts.yazi-downloads =
#   pkgs.writers.writeFishBin "yd" { } # fish
#     ''
#       block --global
#       cd ~/Downloads; or return

#       function most-recent
#           set -l latest_mtime 0
#           set -l latest_file
#           for f in *
#               set -l mtime (path mtime $f)
#               if test $mtime -gt $latest_mtime
#                   set latest_mtime $mtime
#                   set latest_file $f
#               end
#           end

#           echo $latest_file
#       end

#       # Find most recent file
#       set -l file (most-recent)
#       command yazi $file
#       # inputs.yazi.packages.${pkgs.system}.default;
#     '';
