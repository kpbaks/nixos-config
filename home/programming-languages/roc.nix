{ pkgs, ... }:
{

  # https://www.nushell.sh/book/externs.html
  programs.nushell.extraConfig = # nu
    ''
      # export extern roc []
    '';

  xdg.configFile."fish/completions/roc.fish".text = # fish
    ''
      set -l c complete -c roc

      $c -s h -l help -d "Print help"
      $c -s V -l version -d "Print version"
      $c -l fuzz -d "Instrument the roc binary for fuzzing with roc-fuzz"
      $c -l optimize
      $c -l max-threads --exclusive
      $c -l opt-size
      $c -l dev
      $c -l emit-llvm-ir
      $c -l profilling
      $c -l time
      $c -l linker --exclusive -a "surgical legacy"

      set -l commands build test repl run dev format version check docs glue preprocess-host help

      set -l cond "not __fish_seen_subcommand_from $commands"

      for command in $commands
        $c -n $cond -a $command
      end
    '';
}
