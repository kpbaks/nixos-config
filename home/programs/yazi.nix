{ pkgs, ... }:
let
  scripts.yazi-downloads =
    pkgs.writers.writeFishBin "yd" { } # fish
      ''
        block --global
        cd ~/Downloads; or return

        function most-recent
            set -l latest_mtime 0
            set -l latest_file
            for f in *
                set -l mtime (path mtime $f)
                if test $mtime -gt $latest_mtime
                    set latest_mtime $mtime
                    set latest_file $f
                end
            end

            echo $latest_file
        end

        # Find most recent file
        set -l file (most-recent)
        command yazi $file
        # inputs.yazi.packages.${pkgs.system}.default;
      '';
in
{
  programs.yazi =
    let
      plugins-repo = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "a8421d98bbea11bee242883f2f7420e5ca498b3f";
        hash = "sha256-0RZHBF2J2jMbCHcM71lHdn99diDr0zrMiorFgtVL5pI=";
      };
      kdeconnect-yazi = pkgs.fetchFromGitHub {
        owner = "kpbaks";
        repo = "kdeconnect.yazi";
        rev = "f6ae6bd007be970ac17fafc0a84d87eeeb1c4494";
        hash = "sha256-sr92pLVzY/f+MnhhAEbdefz99QdlZRN3x+yQFtXUMD8=";
      };
    in
    {
      enable = true;
      # https://yazi-rs.github.io/docs/quick-start#shell-wrapper
      enableFishIntegration = true;
      shellWrapperName = "y";
      # catppuccin.enable = false;
      # TODO: add to overlay
      package = pkgs.yazi;
      # package = inputs.yazi.packages.${pkgs.system}.default;
      settings = {
        manager = {
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
        # which = {sort_by = true;};

        preview = {
          max_width = 1000;
          max_height = 1000;
        };

        plugin.prepend_fetchers = [
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

      };

      plugins = {
        chmod = "${plugins-repo}/chmod.yazi";
        full-border = "${plugins-repo}/full-border.yazi";
        max-preview = "${plugins-repo}/max-preview.yazi";
        git = "${plugins-repo}/git.yazi";
        no-status = "${plugins-repo}/no-status.yazi";
        # TODO: setup this plug
        mime-ext = "${plugins-repo}/mime-ext.yazi";
        smart-filter = "${plugins-repo}/smart-filter.yazi";
        jump-to-char = "${plugins-repo}/jump-to-char.yazi";
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
          require("kdeconnect"):setup {
            device = "c439e91904ce0298"
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
          manager.prepend_keymap =
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
                run = "arrow 999999999";
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
              (cd "m" "~/Music")
              (cd "p" "~/Pictures")
              (cd "b" "~/Documents") # b for books, which I mostly keep in my ~/Documents folder
              (cd "v" "~/Videos")
              (cd "." "~/dotfiles")
              (cd "r" "/") # r for root
              (cd "/" "/")
              (cd "s" "~/Pictures/screenshots")
              (cd "Do" "~/development/own")
              (cd "Df" "~/development/forks")
              (cd "Dc" "~/development/cloned")
              # (cd "y" "~/.config/yazi")

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
            ];
        };
    };

  home.packages =
    builtins.attrValues scripts
    ++ (with pkgs; [
      p7zip # opt dependency of `yazi`
      ueberzugpp # opt dependency of `yazi`
      exiftool # needed for `yazi` functionality

    ]);
}
