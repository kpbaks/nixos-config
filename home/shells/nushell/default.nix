# TODO: add this to work laptop https://github.com/nushell/nu_scripts/blob/main/custom-completions/winget/winget-completions.nu
# TODO: integrate this: https://github.com/sigoden/argc-completions
{
  config,
  # lib,
  pkgs,
  ...
}:
{

  imports = [
    ./plugins.nix
    ./functions
    # ./hooks
  ];

  # TODO: add to helix
  home.packages = with pkgs; [
    nufmt
    nu_scripts # TODO: use
  ];

  programs.starship.enableNushellIntegration = false;
  # https://github.com/nushell/nushell/blob/f33a26123c9d903f6f9e00eb18903d6aed6fad51/crates/nu-utils/src/default_files/doc_config.nu
  programs.nushell.configFile.text =
    # nu
    ''
      $env.config.completions.algorithm = "fuzzy"
      $env.config.render_right_prompt_on_last_line = false
      $env.config.use_kitty_protocol = true
      $env.config.highlight_resolved_externals = true
      $env.config.display_errors.exit_code = true

      $env.config.color_config = {
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

      let mime_to_lang = {
          application/json: json,
          application/xml: xml,
          application/yaml: yaml,
          text/csv: csv,
          text/tab-separated-values: tsv,
          text/x-toml: toml,
          text/markdown: markdown,
      }

      # https://github.com/nushell/nushell/issues/13444#issuecomment-2552671868
      $env.config.hooks.display_output = {
          metadata access {|meta| match $meta.content_type? {
              null => {}
              "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
              $mimetype if $mimetype in $mime_to_lang => { ^bat -Ppf --language=($mime_to_lang | get $mimetype) },
              _ => {},
          }}
          | if (term size).columns >= 100 { table -e } else { table }
      }

      $env.config.show_banner = false
      $env.config.filesize.unit = "metric"
      $env.config.color_config.int = { if $in > 0 { "green" } else if $in == 0 { "white" } else { "red" } }
      $env.config.ls = {
        clickable_links: true
        use_ls_colors: true
      }

      $env.config.table = {
        mode: rounded
        header_on_separator: true
        # footer_mode: auto
        footer_inheritance: true # TODO(pr): only use if output table does not fit within terminal window
        padding: {left: 0 right: 0}
        index_mode: auto
        # abbreviated_row_count: 10
      }
      # TODO: finish this
      $env.config.hooks.command_not_found = [
        {|cmd_name|
        # if you type a git url, then suggest to clone it
        # git@codeberg.org:kpbaks/permalink-ls.git
        }
      ]


      # TODO: figure out how to make a fg/bg toggle keybind
      $env.config.keybindings = [
        # {
        #   name: ctrl-z
        #   modifier: control
        #   keycode: char_z
        #   mode: emacs
        #   event: { send: }
        # }
      ]
    '';
  # https://github.com/nushell/nushell/tree/main/crates/nu-utils/src/default_files
  programs.nushell = {
    enable = true;
    shellAliases = {
      # g = "git";
      # ll = "ls -l";
      # la = "ls -a";
      # lla = "ls -al";
      fg = "job unfreeze"; # 🤤
      jobs = "job list";
    };
    extraConfig =
      # nu
      ''
        # use std


        # TODO: implement
        def modified [] { ${pkgs.git}/bin/git ls-files --others --exclude-standard | lines }

        # def "config diff" [] {
        #   if $env.KITTY_PID? != null {
        #     let default_config = (^mktemp --suffix=.nu)
        #     config nu --default | save --force $default_config
        #     ${pkgs.kitty}/bin/kitten diff $default_config $nu.config-path
        #     rm $default_config
        #   } else {
        #     config nu --default | ${pkgs.lib.getExe config.programs.vscode.package} --diff - $nu.config-path
        #   }
        # }


        # def --env cdn [] { cd /etc/nixos; $t{config.programs.helix.package}/bin/hx flake.nix }
        def --env cdn [] { cd /etc/nixos }

        def --env cdp [] { cd ~/Pictures }
        def --env cdv [] { cd ~/Videos }
        def --env cdd [] { cd ~/Documents }
        def --env cddl [] { cd ~/Downloads }
        def --env cddt [] { cd ~/Desktop }
        def --env cdm [] { cd ~/Music }
        def --env cdsc [] { cd ~/Videos/Screencasts };
        def --env cdsh [] { cd ~/Pictures/screenshots };
        def --env cddev [] { cd ~/development/own }

        # https://www.nushell.sh/blog/2024-05-15-bashisms.html
        # print "!! - Repeat the last command."
        # print "!n - Repeat the nth command from your nushell history."
        # print "!-n - Repeat the nth command from your last history entry."
        # print "!\$ - Get the last spatially separated token from the last command in your history."
        # print "!term - Repeat the last command match a strings beginning."


        # TODO: parse the format of /etc/fstab
        # def "from fstab" []: [string ->
      '';
  };

}
