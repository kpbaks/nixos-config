{
  programs.fish.functions.kcm = "kcmshell6 --highlight $argv";
  xdg.configFile."fish/completions/kcm.fish".text =
    # fish
    ''
      complete -c kcm -f
      complete -c kcm -a "(kcmshell6 --list 2>/dev/null | tail +2 | string replace --regex '^(\S+) +- (.+)\$' '\$1\t\$2')"
    '';
}
