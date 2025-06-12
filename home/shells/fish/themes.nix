{
  config,
  pkgs,
  ...
}:
{
  # 		# name: 'Cool Beans'
  # # preferred_background: black

  # fish_color_autosuggestion 666
  # fish_color_cancel -r
  # fish_color_command normal
  # fish_color_comment '888'  '--italics'
  # fish_color_cwd 0A0
  # fish_color_cwd_root A00
  # fish_color_end 009900
  #

  # Based on the colors used in Grafana's various documentation
  xdg.configFile."fish/themes/grafana.theme".text = # fish
    ''
      # name: 'Grafana'
      # preferred_background: black

      fish_color_keyword 585ba8 --bold
      fish_color_quote eb9457
      fish_color_command ffffff --bold
      fish_color_comment 9292a5 --italics
      fish_color_option fbc55a
      fish_color_param dddddd
      # fish_color_autosuggestion 666
      # fish_color_cancel -r
      # fish_color_cwd 0A0
      # fish_color_cwd_root A00
      # fish_color_end 009900
      # fish_color_valid_path 3d7bd9 --background e6e6ea --bold
    '';

  # TODO: finish and upstream
  # https://github.com/eldritch-theme?q=kitty&type=all&language=&sort=
  xdg.configFile."fish/themes/eldritch.theme".text = # fish
    ''
      # name: 'Eldritch'
      # preferred_background: black

      # fish_color_keyword 585ba8 --bold
      # fish_color_quote eb9457
      # fish_color_command ffffff --bold
      # fish_color_comment 9292a5 --italics
      # fish_color_option fbc55a
      # fish_color_param dddddd
      # fish_color_autosuggestion 666
      # fish_color_cancel -r
      # fish_color_cwd 0A0
      # fish_color_cwd_root A00
      # fish_color_end 009900
      # fish_color_valid_path 3d7bd9 --background e6e6ea --bold
    '';
}
