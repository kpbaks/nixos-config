{ config, pkgs, ... }:
let
  zellij = "${config.programs.zellij.package}/bin/zellij";
  kitty = "${config.programs.kitty.package}/bin/kitty";
  hx = "${config.programs.helix.package}/bin/hx";
  waybar = "${config.programs.waybar.package}/bin/waybar";
  script =
    pkgs.writers.writeFishBin "waybar.edit-ephemeral" { }
      # fish
      ''
        block --local

        builtin cd (command mktemp --directory)
        pwd
        test -d ~/.config/waybar; or return
        command cp (path resolve ~/.config/waybar/config) config.jsonc
        command cp (path resolve ~/.config/waybar/style.css) style.css
        command chmod +w config.jsonc style.css
        # for f in config style.css
        #     command cp (path resolve ~/.config/waybar/$f) .
        # end

        # command cp ~/.config/waybar/{config,style.css} .

        for scope in "" --user
            systemctl $scope status waybar.service >&2 2>/dev/null
            if test $status -eq 3
                ${pkgs.systemd}/bin/systemctl $scope stop $waybar.service
                break
            end
        end

        command ${pkgs.procps}/bin/pkill waybar

        # command waybar --config config --style style.css

        set -l layout layout.kdl
        echo '
        layout {
            tab focus=true {
                pane split_direction="vertical" {
                    pane focus=true command="${hx}" {
                        args "config.jsonc" "style.css"
                    }
                    pane split_direction="horizontal" {
                        pane command="${waybar}" {
                            args "--config=config.jsonc" "--style=style.css"   
                        }
                        pane command="${pkgs.watchexec}/bin/watchexec" {
                            args "--watch=." "pkill" "-USR2" "waybar"
                        }
                    }
                }
            }

            tab name="config diff" {
                pane command="${pkgs.diffutils}/bin/diff" close_on_exit=false {
                    args = "config.jsonc" "~/.config/waybar/config"
                }
            }

            tab name="style.css diff" {
                pane command="${pkgs.diffutils}/bin/diff" close_on_exit=false {
                    args = "style.css" "~/.config/waybar/style.css"
                }
            }
        }
        ' >$layout

        ${kitty} --config (command mktemp) ${zellij} --layout $layout
      '';
in
{
  home.packages = [ script ];
}
