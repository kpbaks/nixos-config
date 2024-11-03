# TODO: add this to work laptop https://github.com/nushell/nu_scripts/blob/main/custom-completions/winget/winget-completions.nu
# TODO: integrate this: https://github.com/sigoden/argc-completions
{ config, pkgs, ... }:
{

  imports = [
    # ./plugins.nix
    ./functions
  ];

  # TODO: add to helix
  home.packages = with pkgs; [ nufmt ];

  programs.nushell.configFile.text =
    # nushell
    ''
      $env.config = {
        color_config: {
          search_result: blue_reverse
        }
        ls: { use_ls_colors: true }
        table: {
          mode: rounded
        }
        use_kitty_protocol: true
        highlight_resolved_externals: true
        display_errors: {
          exit_code: true
        }
        render_right_prompt_on_last_line: true
        completions: {
          algorithm: fuzzy
        }
      # edit_mode: vi
      }
        
    '';
  programs.nushell = {
    enable = true;
    extraConfig =
      # nushell
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

        def cdn [] { cd /etc/nixos; ${config.programs.helix.package}/bin/hx flake.nix }

      '';
  };

  # # FIXME: how to add these to nushell config?
  # home.packages = with pkgs.nushellPlugins; [
  #   formats
  #   polars
  #   gstat
  #   net
  #   query
  # ];
}
