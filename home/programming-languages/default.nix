{ pkgs, ... }:
{
  imports = [
    ./csharp.nix
    # ./cpp.nix
    # ./go.nix
    # ./java.nix
    # ./julia.nix
    # ./odin.nix
    ./python.nix
    # ./ocaml.nix
    # ./roc.nix
    ./rust.nix
    # ./zig.nix
    ./dockerfile.nix
  ];

  programs.gcc = {
    enable = true;
    package = pkgs.gcc;
    colors = {
      error = "01;31";
    };
  };

  # https://github.com/koalaman/shellcheck/wiki/Directive#shellcheckrc-file
  xdg.configFile."shellcheckrc".text =
    # shellcheckrc
    ''
      # https://github.com/koalaman/shellcheck/wiki/Directive#enable
      # `nix run nixpkgs#shellcheck -- --list-optional | nix run nixpkgs#gawk '/^name:/ {printf "enable=%s\n", $2}'`
      enable=add-default-case
      enable=avoid-nullary-conditions
      enable=check-extra-masked-returns
      enable=check-set-e-suppressed
      enable=check-unassigned-uppercase
      enable=deprecate-which
      enable=quote-safe-variables
      enable=require-double-brackets
      enable=require-variable-braces

      external-sources=false
    '';
}
