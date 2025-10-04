{
  home.sessionVariables =

    let
      reset = "'\e[0m'";
    in
    {

      # TODO: finish these
      # https://www.tiger-computing.co.uk/linux-tips-colourful-man-pages/
      LESS_TERMCAP_mb = ""; # begin blinking
      LESS_TERMCAP_md = ""; # begin bold
      LESS_TERMCAP_me = reset; # end mode
      LESS_TERMCAP_se = reset; # end standout-mode
      LESS_TERMCAP_so = ""; # begin standout-mode
      LESS_TERMCAP_ue = reset; # end underline
      LESS_TERMCAP_us = ""; # begin underline

      # NOTE: file generated with `vivid generate <theme>`
      # TODO: generate from this https://musca.github.io/github-lang-colors/
      LS_COLORS = builtins.readFile ./LS_COLORS;
    };

}
