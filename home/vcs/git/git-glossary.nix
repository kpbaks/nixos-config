{ config, pkgs, ... }:
let
  git-glossary =
    pkgs.writers.writeNuBin "git-glossary" { }
      # nu
      ''

        echo "todo"
        let url = "https://git-scm.com/docs/gitglossary"
        # http get $url | query web --query
        # https://docs.github.com/en/get-started/learning-about-github/github-glossary
      '';
in
{
  home.packages = [ git-glossary ];
}
