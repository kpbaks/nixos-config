{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lldb
    zls
    # zig
  ];

  programs.nushell.extraConfig =
    # nu
    ''
      def "zig env" [] { ^zig env | from json }
      def "zig targets" [] { ^zig targets | from json }
    '';

  # programs.fish.functions.zig = {
  #   body = # fish
  #   ''
  #   if isatty stdout; and (count $argv) -gt 0; and $argv[1] = env

  #   end
  #   '';
  # };
}
