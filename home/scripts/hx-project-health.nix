{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "hx-project-health" { }
      # nu
      ''
        let extensions = glob **

        # TODO: make ripgrep not look at users ripgreprc? to ensure reliable results?
        ${pkgs.ripgrep}/bin/rg --type-list
        | lines
        | parse "{type}: {patterns}"
        | update patterns {|it| }
        # | each {}

        # rg --type-list | lines | each { |line| $line | parse "{type}: {patterns}" | update patterns
        # --type
      '';
in
{
  home.packages = [ script ];
}
