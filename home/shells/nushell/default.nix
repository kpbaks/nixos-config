# TODO: add this to work laptop https://github.com/nushell/nu_scripts/blob/main/custom-completions/winget/winget-completions.nu
# TODO: integrate this: https://github.com/sigoden/argc-completions
{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    ./plugins.nix
    ./functions
  ];

  # TODO: add to helix
  home.packages = with pkgs; [ nufmt ];

  programs.nushell.configFile.text =
    # nu
    ''
      let mime_to_lang = {
          application/json: json,
          application/xml: xml,
          application/yaml: yaml,
          text/csv: csv,
          text/tab-separated-values: tsv,
          text/x-toml: toml,
          text/markdown: markdown,
      }

      $env.config = {
        color_config: {
          separator: gray
          search_result: blue_reverse
          header: green_bold
          # header: {fg: bold_black bg: cyan}
          row_index: header
          bool: { if $in { "green" } else { "red" } }
          int: blue
          float: yellow
          nothing: dark_red
          # detect anything that looks like a hex color and display that color
          string: {|| if $in =~ '^#[a-fA-F\d]+' { $in } else { 'default' } }
        }
        ls: { use_ls_colors: true }
        table: {
          mode: rounded
          header_on_separator: true
        }
        use_kitty_protocol: true
        highlight_resolved_externals: true
        display_errors: {
          exit_code: true
        }
        render_right_prompt_on_last_line: false
        completions: {
          algorithm: fuzzy
        }
      # https://github.com/nushell/nushell/issues/13444#issuecomment-2552671868
      # $env.config.hooks.display_output = {
      hooks.display_output = {
        metadata access {|meta| match $meta.content.type? {
          null => {}
          "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
          $mimetype if $mimetype in $mime_to_lang => { ${lib.getExe config.programs.bat.package} --plain --paging=never f --language=($mime_to_lang | get $mimetype) },
          _ => {}
        }}
        | if (term.size).columns >= 100 { table --expand } else { table }
      }

      # edit_mode: vi
      }

        
    '';
  programs.nushell = {
    enable = true;
    extraConfig =
      # nu
      ''
        # use std


        # TODO: implement
        def modified [] { ${pkgs.git}/bin/git ls-files --others --exclude-standard | lines }

        def "config diff" [] {
          if $env.KITTY_PID? != null {
            let default_config = (^mktemp --suffix=.nu)
            config nu --default | save --force $default_config
            ${pkgs.kitty}/bin/kitten diff $default_config $nu.config-path
            rm $default_config
          } else {
            config nu --default | ${pkgs.lib.getExe config.programs.vscode.package} --diff - $nu.config-path
          }
        }

        alias ll = ls --long
        alias la = ls --all
        alias lla = ls --long --all

        def --env cdn [] { cd /etc/nixos; ${config.programs.helix.package}/bin/hx flake.nix }

        def --env cdp [] { cd ~/Pictures }
        def --env cdv [] { cd ~/Videos }
        def --env cdd [] { cd ~/Documents }
        def --env cddl [] { cd ~/Downloads }
        def --env cddt [] { cd ~/Desktop }
        def --env cdm [] { cd ~/Music }
        def --env cdsc [] { cd ~/Videos/Screencasts };
        def --env cdsh [] { cd ~/Pictures/screenshots };
        def --env cddev [] { cd ~/development/own }

        alias lg = ${config.programs.lazygit.package}/bin/lazygit

        # https://www.nushell.sh/blog/2024-05-15-bashisms.html
        print "!! - Repeat the last command."
        print "!n - Repeat the nth command from your nushell history."
        print "!-n - Repeat the nth command from your last history entry."
        print "!\$ - Get the last spatially separated token from the last command in your history."
        print "!term - Repeat the last command match a strings beginning."
      '';
  };

  programs.starship.enableNushellIntegration = false;
}